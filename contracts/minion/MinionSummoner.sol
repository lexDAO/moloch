pragma solidity 0.5.17;

import "./Minion.sol";

contract MinionSummoner {
    Minion private minion;
    address public molochSummoner;
    uint8 private status;
    uint8 private NOT_SET;
    uint8 private constant SET = 1;
    
    event SummonMinion(address indexed minion);

    constructor() public {
        status = NOT_SET;
    }

    function setMolochSummoner(address _molochSummoner) external {
        require(status != SET, "already set");
        molochSummoner = _molochSummoner;
        status = SET; // lock minionSummoner to molochSummoner
    }

    function summonMinion(address _moloch, address _molochDepositToken) external {
        require(msg.sender == molochSummoner, "not molochSummoner");
        minion = new Minion(_moloch, _molochDepositToken); // summon minion for parent moloch
        
        emit SummonMinion(address(minion));
    }
}
