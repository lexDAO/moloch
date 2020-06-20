pragma solidity 0.5.17;

import "./Minion.sol";

contract MinionSummoner {
    Minion private minion;
    address[] public minions;

    event Summoned(address indexed minion, address moloch);

    function summonMinion(address _moloch) public {
        minion = new Minion(_moloch);
        
        minions.push(address(minion));
        emit Summoned(address(minion), _moloch);
    }
}