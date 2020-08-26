pragma solidity 0.5.17;

import "./Moloch.sol";
import "./CloneFactory.sol";

contract MysticSummoner is CloneFactory { 
    address payable public template;
    
    constructor (address payable _template) public {
        template = _template;
    }

    event SummonMystic(address indexed myx, address depositToken, address stakeToken, address[] summoner, uint256[] summonerShares, uint256 summoningDeposit, uint256 proposalDeposit, uint256 processingReward, uint256 periodDuration, uint256 votingPeriodLength, uint256 gracePeriodLength, uint256 dilutionBound, uint256 summoningTime);
 
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
    ) public returns (address) {
        Mystic myx = Mystic(createClone(template));
        
        myx.init(
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
        
        require(IERC20(_depositToken).transferFrom(msg.sender, address(myx), _summonerDeposit), "!transfer"); // transfer summoner deposit to new Mystic
        
        emit SummonMystic(address(myx), _depositToken, _stakeToken, _summoner, _summonerShares, _summonerDeposit, _proposalDeposit, _processingReward, _periodDuration, _votingPeriodLength, _gracePeriodLength, _dilutionBound, now);
        
        return address(myx);
    }
}
