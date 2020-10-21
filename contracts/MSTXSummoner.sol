pragma solidity 0.6.12;

import "./Mystic.sol";
import "./CloneFactory.sol";

contract MSTXSummoner is CloneFactory { 
    address payable public immutable template;
    
    constructor(address payable _template) public {
        template = _template;
    }

    event SummonMSTX(address indexed mstx, address depositToken, address stakeToken, address[] summoner, uint256[] summonerShares, uint256 summoningDeposit, uint256 proposalDeposit, uint256 processingReward, uint256 periodDuration, uint256 votingPeriodLength, uint256 gracePeriodLength, uint256 dilutionBound, uint256 summoningTime);
 
    function summonMSTX(
        address _depositToken,
        address _stakeToken,
        address[] memory _summoner,
        uint256[] memory _summonerShares,
        uint256 _summonerDeposit,
        uint256 _proposalDeposit,
        uint256 _processingReward,
        uint256 _periodDuration,
        uint256 _votingPeriodLength,
        uint256 _gracePeriodLength,
        uint256 _dilutionBound
    ) external returns (address) {
        MSTX mstx = MSTX(createClone(template));
        
        mstx.init(
            _depositToken,
            _stakeToken,
            _summoner,
            _summonerShares,
            _summonerDeposit,
            _proposalDeposit,
            _processingReward,
            _periodDuration,
            _votingPeriodLength,
            _gracePeriodLength,
            _dilutionBound
        );
        
        require(IERC20(_depositToken).transferFrom(msg.sender, address(mstx), _summonerDeposit), "!transfer"); // transfer summoner deposit to new MSTX
        
        emit SummonMSTX(address(mstx), _depositToken, _stakeToken, _summoner, _summonerShares, _summonerDeposit, _proposalDeposit, _processingReward, _periodDuration, _votingPeriodLength, _gracePeriodLength, _dilutionBound, now);
        
        return address(mstx);
    }
}
