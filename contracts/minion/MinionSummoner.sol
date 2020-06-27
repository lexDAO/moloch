pragma solidity 0.5.17;

import "./Minion.sol";

contract MinionSummoner {
    Minion private minion;
    address[] public molochs; // tracks summoned molochs for set
    address public molochSummoner;
    uint256 private _status;
    uint256 private constant _NOT_SET = 0;
    uint256 private constant _SET = 1;
    
    event Summoned(address indexed minion, address indexed moloch);

    constructor () public {
        _status = _NOT_SET;
    }

    function setMolochSummoner(address _molochSummoner) external {
        require(_status != _SET, "already set");
        molochSummoner = _molochSummoner;
        _status = _SET; // locks MinionSummoner to MolochSummoner 
    }

    function summonMinion(address moloch, address _molochDepositToken) public {
        require(msg.sender == molochSummoner, "not molochSummoner");
        minion = new Minion(moloch, _molochDepositToken);
        molochs.push(moloch);
        
        emit Summoned(address(minion), moloch);
    }
}
