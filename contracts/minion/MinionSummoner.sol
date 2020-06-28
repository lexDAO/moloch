pragma solidity 0.5.17;

import "./Minion.sol";

contract MinionSummoner {
    Minion private minion;
    address[] public molochs; // tracks summoned molochs for set
    address public molochSummoner;
    uint256 private status;
    uint256 private NOT_SET;
    uint256 private constant SET = 1;
    
    event Summoned(address indexed minion, address indexed moloch);

    constructor() public {
        status = NOT_SET;
    }

    function setMolochSummoner(address _molochSummoner) external {
        require(status != SET, "already set");
        molochSummoner = _molochSummoner;
        status = SET; // locks molochSummoner to this contract set
    }

    function summonMinion(address moloch, address _molochDepositToken) public {
        require(msg.sender == molochSummoner, "not molochSummoner");
        minion = new Minion(moloch, _molochDepositToken);
        molochs.push(moloch);
        
        emit Summoned(address(minion), moloch);
    }
}
