pragma solidity 0.5.17;

import "./Minion.sol";

contract MinionSummoner {
    Minion private minion;
    address[] public molochs; // tracks summoned molochs for set
    address public molochSummoner;
    bool private molochSummonerSet = false; // tracks lock of MinionSummoner to MolochSummoner 

    event Summoned(address indexed minion, address indexed moloch);
    
    function setMolochSummoner(address _molochSummoner) public {
        require(molochSummonerSet == false, "molochSummoner already set");
        molochSummoner = _molochSummoner;
        molochSummonerSet = true; // locks MinionSummoner to MolochSummoner 
    }

    function summonMinion(address moloch, address _molochDepositToken) public {
        require(msg.sender == molochSummoner, "not molochSummoner");
        minion = new Minion(moloch, _molochDepositToken);
        
        emit Summoned(address(minion), moloch);
    }
}
