pragma solidity 0.5.17;

import "./Moloch.sol";
import "./ISummonMinion.sol";

contract MolochSummoner {
    Moloch private baal;

    event SummonMoloch(address indexed baal, address[] indexed summoners, address indexed depositToken, uint256 periodDuration, uint256 votingPeriodLength, uint256 gracePeriodLength, uint256 proposalDeposit, uint256 dilutionBound, uint256 processingReward, uint256[] summonerStake, uint256 summoningDeposit, uint256 summoningRate, uint256 summoningTermination, uint256 summoningTime);

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
        
        IERC20(_depositToken).transferFrom(msg.sender, address(baal), _summoningDeposit); // transfer summoning deposit to new moloch

        emit SummonMoloch(address(baal), _summoners, _depositToken, _periodDuration, _votingPeriodLength, _gracePeriodLength, _proposalDeposit, _dilutionBound, _processingReward, _summonerShares, _summoningDeposit, _summoningRate, _summoningTermination, now);
    }
}
