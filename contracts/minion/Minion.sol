pragma solidity 0.5.17;

import "./IMoloch.sol";

contract Minion {
    IMoloch public moloch;
    address private molochDepositToken;
    string public constant MINION_ACTION_DETAILS = '{"isMinion": true, "title":"MINION", "description":"';
    mapping(uint256 => Action) public actions; // proposalId => Action

    struct Action {
        uint256 value;
        address to;
        address proposer;
        bool executed;
        bytes data;
    }

    event ProposeAction(uint256 proposalId, address proposer);
    event ExecuteAction(uint256 proposalId, address executor);

    constructor(address _moloch, address _molochDepositToken) public {
        moloch = IMoloch(_moloch);
        molochDepositToken = _molochDepositToken;
        moloch.setMinion(address(this));
    }

    // withdraw funds from the moloch
    function doWithdraw(address _token, uint256 _amount) public {
        moloch.withdrawBalance(_token, _amount);
    }

    function proposeAction(
        address _actionTo,
        uint256 _actionValue,
        bytes memory _actionData,
        bytes32 _description
    ) public returns (uint256) {
        // No calls to zero address allows us to check that minion submitted
        // the proposal without getting the proposal struct from the moloch
        require(_actionTo != address(0), "invalid _actionTo");

        bytes32 details = keccak256(abi.encodePacked(MINION_ACTION_DETAILS, _description, '"}'));

        uint256 proposalId = moloch.submitProposal(
            address(this),
            0,
            0,
            0,
            molochDepositToken,
            0,
            molochDepositToken,
            details
        );

        Action memory action = Action({
            value: _actionValue,
            to: _actionTo,
            proposer: msg.sender,
            executed: false,
            data: _actionData
        });

        actions[proposalId] = action;

        emit ProposeAction(proposalId, msg.sender);
        return proposalId;
    }

    function executeAction(uint256 _proposalId) public returns (bytes memory) {
        Action memory action = actions[_proposalId];
        bool[6] memory flags = moloch.getProposalFlags(_proposalId);

        // minion did not submit this proposal
        require(action.to != address(0), "invalid _proposalId");
        // can't call arbitrary functions on parent moloch
        require(action.to != address(moloch), "invalid target");
        require(!action.executed, "action executed");
        require(address(this).balance >= action.value, "insufficient eth");
        require(flags[2], "proposal not passed");

        // execute call
        actions[_proposalId].executed = true;
        (bool success, bytes memory retData) = action.to.call.value(action.value)(action.data);
        require(success, "call failure");
        emit ExecuteAction(_proposalId, msg.sender);
        return retData;
    }

    function() external payable {}
}
