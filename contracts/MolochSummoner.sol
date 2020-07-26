pragma solidity 0.5.17;

import "./Moloch.sol";

contract MolochSummoner {
    Moloch private baal;

    event SummonMoloch(address indexed baal, address[] indexed summoner, address indexed depositToken, uint256[] summonerLoot, uint256[] summonerShares, uint256 summoningDeposit, uint256 periodDuration, uint256 votingPeriodLength, uint256 gracePeriodLength, uint256 proposalDeposit, uint256 dilutionBound, uint256 processingReward, uint256 summoningTime);

    function summonMoloch(
        address[] memory _summoner,
        address _depositToken,
        uint256[] memory _summonerShares,
        uint256[] memory _summonerLoot,
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
            _summonerLoot,
            _summonerDeposit,
            _periodDuration,
            _votingPeriodLength,
            _gracePeriodLength,
            _proposalDeposit,
            _dilutionBound,
            _processingReward);
        
        IERC20(_depositToken).transferFrom(msg.sender, address(baal), _summonerDeposit); // transfer summoner deposit to new moloch

        emit SummonMoloch(address(baal), _summoner, _depositToken, _summonerShares, _summonerLoot, _summonerDeposit, _periodDuration, _votingPeriodLength, _gracePeriodLength, _proposalDeposit, _dilutionBound, _processingReward, now);
    }
}
