pragma solidity 0.5.17;

import "./Moloch.sol";
import "./ISummonMinion.sol";

contract MolochSummoner {
    Moloch private baal;
    ISummonMinion public minionSummoner;
    address[] public molochs;

    event Summoned(address indexed mol, address[] indexed _summoners);
    
    constructor(address _minionSummoner) public {
       minionSummoner = ISummonMinion(_minionSummoner);
    }

    function summonMoloch(
        address[] memory _summoners,
        address[] memory _approvedTokens,
        uint256 _periodDuration,
        uint256 _votingPeriodLength,
        uint256 _gracePeriodLength,
        uint256 _proposalDeposit,
        uint256 _dilutionBound,
        uint256 _processingReward) public {

        baal = new Moloch(
            _summoners,
            _approvedTokens,
            _periodDuration,
            _votingPeriodLength,
            _gracePeriodLength,
            _proposalDeposit,
            _dilutionBound,
            _processingReward);
        
        address mol = address(baal);
        molochs.push(mol);
        minionSummoner.summonMinion(mol, _approvedTokens[0]);
        emit Summoned(mol, _summoners);
    }
}
