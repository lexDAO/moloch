pragma solidity 0.5.17;

import "./Minion.sol";

contract MinionSummoner {
    Minion private minion;
    
    event SummonMinion(address indexed minion, address indexed moloch);

    function summonMinion(address _moloch, address _molochDepositToken) external {
        minion = new Minion(_moloch, _molochDepositToken); // summon minion for parent moloch
        
        emit SummonMinion(address(minion), _moloch);
    }
}
