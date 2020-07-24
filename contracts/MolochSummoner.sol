pragma solidity 0.5.17;

import "./Moloch.sol";
import "./ISummonMinion.sol";

contract MolochSummoner {
    Moloch private baal;
    ISummonMinion public minionSummoner;
    
    event SummonMoloch(address indexed moloch, address[] indexed summoners, address indexed depositToken, uint256 summoningTime, uint256 periodDuration, uint256 votingPeriodLength, uint256 gracePeriodLength, uint256 proposalDeposit, uint256 dilutionBound, uint256 processingReward, uint256[] summonerStake, uint256 summoningDeposit, uint256 summoningRate, uint256 summoningTermination);
    
    constructor(address _minionSummoner) public { 
        minionSummoner = ISummonMinion(_minionSummoner);
        minionSummoner.setMolochSummoner(address(this)); // lock minionSummoner to molochSummoner
    }

    function summonMoloch(
        address[] memory _summoners,
        address _depositToken,
        uint256 _periodDuration,
        uint256 _votingPeriodLength,
        uint256 _gracePeriodLength,
        uint256 _proposalDeposit,
        uint256 _dilutionBound,
        uint256 _processingReward,
        uint256[] memory _summonerShares,
        uint256 _summoningDeposit,
        uint256 _summoningRate,
        uint256 _summoningTermination
    ) public {
        baal = new Moloch(
            _summoners,
            _depositToken,
            _periodDuration,
            _votingPeriodLength,
            _gracePeriodLength,
            _proposalDeposit,
            _dilutionBound,
            _processingReward,
            _summonerShares,
            _summoningDeposit,
            _summoningRate,
            _summoningTermination);
        
        address moloch = address(baal);
        
        require(IERC20(_depositToken).transferFrom(msg.sender, moloch, _summoningDeposit), "transfer failed"); // transfer summoning deposit to new moloch
        
        minionSummoner.summonMinion(moloch, _depositToken); // summon minion for new moloch
        
        emit SummonMoloch(moloch, _summoners, _depositToken, now, _periodDuration, _votingPeriodLength, _gracePeriodLength, _proposalDeposit, _dilutionBound, _processingReward, _summonerShares, _summoningDeposit, _summoningRate, _summoningTermination);
    }
}
