pragma solidity 0.5.17;

import "./Minion.sol";

contract MinionSummoner {
    Minion private minion;
    address public molochSummoner;
    address[] public minions;
    address[] public molochs;
    bool private molochSummonerSet = false; // tracks lock of MinionSummoner to MolochSummoner 

    event Summoned(address indexed minion, address moloch);
    
    function setMolochSummoner(address _molochSummoner) public {
        require(molochSummonerSet == false, "molochSummoner already set");
        molochSummoner = _molochSummoner;
        molochSummonerSet = true; // locks MinionSummoner to MolochSummoner
    }

    function summonMinion(address _moloch, address _molochApprovedToken) public {
        require(msg.sender == molochSummoner, "caller not molochSummoner");
        minion = new Minion(_moloch, _molochApprovedToken);
        
        minions.push(address(minion));
        molochs.push(address(_moloch));
        emit Summoned(address(minion), _moloch);
    }
}
