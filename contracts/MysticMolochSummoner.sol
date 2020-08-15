pragma solidity 0.5.17;

import "./Moloch.sol";

contract MysticMolochSummoner { 
    MysticMoloch private baal;

    event SummonMoloch(address indexed baal, address depositToken, address voteToken, address[] summoner, uint256[] summonerShares, uint256 summoningDeposit, uint256 proposalDeposit, uint256 processingReward, uint256 periodDuration, uint256 votingPeriodLength, uint256 gracePeriodLength, uint256 dilutionBound, uint256 summoningTime);
 
    function summonMoloch(
        address _depositToken,
        address _voteToken,
        address[] memory _summoner,
        uint256[] memory _summonerShares,
        uint256 _summonerDeposit,
        uint256 _proposalDeposit,
        uint256 _processingReward,
        uint256 _periodDuration,
        uint256 _votingPeriodLength,
        uint256 _gracePeriodLength,
        uint256 _dilutionBound
    ) public {
        baal = new MysticMoloch(
            _depositToken,
            _voteToken,
            _summoner,
            _summonerShares,
            _summonerDeposit,
            _proposalDeposit,
            _processingReward,
            _periodDuration,
            _votingPeriodLength,
            _gracePeriodLength,
            _dilutionBound);
        
        require(IERC20(_depositToken).transferFrom(msg.sender, address(baal), _summonerDeposit), "!transfer"); // transfer summoner deposit to new moloch

        emit SummonMoloch(address(baal), _depositToken, _voteToken, _summoner, _summonerShares, _summonerDeposit, _proposalDeposit, _processingReward, _periodDuration, _votingPeriodLength, _gracePeriodLength, _dilutionBound, now);
    }
}
