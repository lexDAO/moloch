pragma solidity 0.5.17;

interface Moloch {
    function depositToken() external view returns (address);
    
    function getProposalFlags(uint256 proposalId) external view returns (bool[6] memory);
    
    function submitProposal(
        address applicant,
        uint256 sharesRequested,
        uint256 lootRequested,
        uint256 tributeOffered,
        address tributeToken,
        uint256 paymentRequested,
        address paymentToken,
        string calldata details
    ) external returns (uint256);
    
    function withdrawBalance(address token, uint256 amount) external;
}

contract Minion {
    Moloch public mol;
    string public constant MINION_ACTION_DETAILS = '{"isMinion": true, "title":"MINION", "description":"';
    mapping (uint256 => Action) public actions; // proposalId => Action

    struct Action {
        uint256 value;
        address to;
        address proposer;
        bool executed;
        bytes data;
    }

    event ActionProposed(uint256 proposalId, address proposer);
    event ActionExecuted(uint256 proposalId, address executor);

    constructor(address _moloch) public {
        Moloch moloch = Moloch(_moloch);
        mol = moloch;
    }

    // withdraw funds from the moloch
    function doWithdraw(address _token, uint256 _amount) public {
        mol.withdrawBalance(_token, _amount);
    }

    function proposeAction(
        address _actionTo,
        uint256 _actionValue,
        bytes memory _actionData,
        string memory _description
    )
        public
        returns (uint256)
    {
        // No calls to zero address allows us to check that Minion submitted
        // the proposal without getting the proposal struct from the moloch
        require(_actionTo != address(0), "Minion::invalid _actionTo");

        string memory details = string(abi.encodePacked(MINION_ACTION_DETAILS, _description, '"}'));

        uint256 proposalId = mol.submitProposal(
            address(this),
            0,
            0,
            0,
            getDepositToken(),
            0,
            getDepositToken(),
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

        emit ActionProposed(proposalId, msg.sender);
        return proposalId;
    }

    function executeAction(uint256 _proposalId) public returns (bytes memory) {
        Action memory action = actions[_proposalId];
        bool[6] memory flags = mol.getProposalFlags(_proposalId);

        // minion did not submit this proposal
        require(action.to != address(0), "Minion::invalid _proposalId");
        // can't call arbitrary functions on parent moloch
        require(action.to != address(mol), "Minion::invalid target");
        require(!action.executed, "Minion::action executed");
        require(address(this).balance >= action.value, "Minion::insufficient eth");
        require(flags[2], "Minion::proposal not passed");

        // execute call
        actions[_proposalId].executed = true;
        (bool success, bytes memory retData) = action.to.call.value(action.value)(action.data);
        require(success, "Minion::call failure");
        emit ActionExecuted(_proposalId, msg.sender);
        return retData;
    }
    
    function getDepositToken() public view returns (address) {
        return mol.depositToken();
    }

    function() external payable { }
}

contract MinionSummoner {
    // presented by OpenESQ || LexDAO LLC ~ Use at own risk! || chat with us: lexdao.chat 
    Minion private minion;
    address[] public minions;

    event Summoned(address indexed minion, address moloch);

    function summonMinion(address _moloch) public {
        minion = new Minion(_moloch);
        
        minions.push(address(minion));
        emit Summoned(address(minion), _moloch);
    }
}
