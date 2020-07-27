pragma solidity 0.5.17;

import "./Moloch.sol";

contract MolochSummoner {
    Moloch private baal;
    ISummonMinion public minionSummoner;

    event SummonMoloch(address indexed moloch, address[] indexed summoner, address indexed depositToken, uint256[] summonerShares, uint256 summoningDeposit, uint256 periodDuration, uint256 votingPeriodLength, uint256 gracePeriodLength, uint256 proposalDeposit, uint256 dilutionBound, uint256 processingReward, uint256 summoningTime);
    
    constructor(address _minionSummoner) public { 
        minionSummoner = ISummonMinion(_minionSummoner);
        minionSummoner.setMolochSummoner(address(this)); // lock minionSummoner to molochSummoner
    }
    
    function summonMoloch(
        address[] memory _summoner,
        address _depositToken,
        uint256[] memory _summonerShares,
        uint256 _summonerDeposit,
        uint256 _periodDuration,
        uint256 _votingPeriodLength,
        uint256 _gracePeriodLength,
        uint256 _proposalDeposit,
        uint256 _dilutionBound,
        uint256 _processingReward
    ) public {
        baal = new Moloch(
            _summoner,
            _depositToken,
            _summonerShares,
            _summonerDeposit,
            _periodDuration,
            _votingPeriodLength,
            _gracePeriodLength,
            _proposalDeposit,
            _dilutionBound,
            _processingReward);
        
        address moloch = address(baal);
        
        require(IERC20(_depositToken).transferFrom(msg.sender, moloch, _summonerDeposit), "transfer failed"); // transfer summoner deposit to new moloch
        
        minionSummoner.summonMinion(moloch, _depositToken); // summon minion for new moloch
        
        emit SummonMoloch(moloch, _summoner, _depositToken, _summonerShares, _summonerDeposit, _periodDuration, _votingPeriodLength, _gracePeriodLength, _proposalDeposit, _dilutionBound, _processingReward, now);
    }
}
