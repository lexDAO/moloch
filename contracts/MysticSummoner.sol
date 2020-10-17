pragma solidity 0.6.12;

import "./Mystic.sol";
import "./CloneFactory.sol";

contract MysticSummoner is CloneFactory { 
    address payable public immutable template;
    
    constructor (address payable _template) public {
        template = _template;
    }

    event SummonMystic(address indexed myst, address depositToken, address stakeToken, address[] summoner, uint256[] summonerShares, uint256 summoningDeposit, uint256 proposalDeposit, uint256 processingReward, uint256 periodDuration, uint256 votingPeriodLength, uint256 gracePeriodLength, uint256 dilutionBound, uint256 summoningTime);
 
    function summonMystic(
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
        Mystic myst = Mystic(createClone(template));
        
        myst.init(
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
        
        require(IERC20(_depositToken).transferFrom(msg.sender, address(myst), _summonerDeposit), "!transfer"); // transfer summoner deposit to new Mystic
        
        emit SummonMystic(address(myst), _depositToken, _stakeToken, _summoner, _summonerShares, _summonerDeposit, _proposalDeposit, _processingReward, _periodDuration, _votingPeriodLength, _gracePeriodLength, _dilutionBound, now);
        
        return address(myst);
    }
}
