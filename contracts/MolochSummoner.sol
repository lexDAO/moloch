pragma solidity 0.5.17;

import "./Moloch.sol";
import "./ISummonMinion.sol";

contract MolochSummoner {
    Moloch private baal;
    ISummonMinion public minionSummoner;
    
    event SummonMoloch(address indexed moloch);

    constructor(address _minionSummoner) public { 
        minionSummoner = ISummonMinion(_minionSummoner);
        minionSummoner.setMolochSummoner(address(this)); // locks minionSummoner to molochSummoner
    }

    function summonMoloch(
        address[] memory _summoners,
        address[] memory _approvedTokens,
        uint256 _periodDuration,
        uint256 _votingPeriodLength,
        uint256 _gracePeriodLength,
        uint256 _proposalDeposit,
        uint256 _dilutionBound,
        uint256 _processingReward,
        uint256 _summonerStake,
        uint256 _summoningDeposit,
        uint256 _summoningRate,
        uint256 _summoningTermination
    ) public {
        // new magick set
        baal = new Moloch(
            _summoners,
            _approvedTokens,
            _periodDuration,
            _votingPeriodLength,
            _gracePeriodLength,
            _proposalDeposit,
            _dilutionBound,
            _processingReward,
            _summonerStake,
            _summoningDeposit,
            _summoningRate,
            _summoningTermination);
        
        address moloch = address(baal);
        
        if (_summoningDeposit > 0) {
            require(IERC20(_approvedTokens[0]).transferFrom(msg.sender, moloch, _summoningDeposit), "transfer failed"); // transfer summoning deposit to new moloch
        }
       
        minionSummoner.summonMinion(moloch, _approvedTokens[0]); // summons minion for new moloch
        
        emit SummonMoloch(moloch);
    }
}
