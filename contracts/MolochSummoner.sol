pragma solidity 0.5.17;

import "./Moloch.sol";
import "./ISummonMinion.sol";

contract MolochSummoner {
    Moloch private moloch;
    ISummonMinion public minionSummoner;

    constructor(address _minionSummoner) public { // locks minionSummoner to contract set
        minionSummoner = ISummonMinion(_minionSummoner);
        minionSummoner.setMolochSummoner(address(this));
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
        uint256 _summoningRate,
        uint256 _summoningTermination,
        bytes32 _manifesto
    ) public {
        moloch = new Moloch(
            _summoners,
            _approvedTokens,
            _periodDuration,
            _votingPeriodLength,
            _gracePeriodLength,
            _proposalDeposit,
            _dilutionBound,
            _processingReward, 
            _summoningRate,
            _summoningTermination,
            _manifesto);
        
        minionSummoner.summonMinion(address(moloch), _approvedTokens[0]); // summons minion for new moloch
    }
}
