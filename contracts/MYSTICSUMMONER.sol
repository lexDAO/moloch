pragma solidity 0.6.12;

import "./MYSTIC.sol";
import "./CloneFactory.sol";

contract MYSTICSUMMONER is CloneFactory { 
    address payable public immutable template;
    
    constructor(address payable _template) public {
        template = _template;
    }

    event SummonMYSTIC(address indexed mystic, address depositToken, address stakeToken, address[] summoner, uint256[] summonerShares, uint256 summoningDeposit, uint256 proposalDeposit, uint256 processingReward, uint256 periodDuration, uint256 votingPeriodLength, uint256 gracePeriodLength, uint256 dilutionBound, uint256 summoningTime);
 
    function summonMYSTIC(
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
        uint256 _dilutionBound,
        string memory _guildName
    ) external returns (address) {
        MYSTIC mystic = MYSTIC(createClone(template));
        
        mystic.init(
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
            _dilutionBound,
            _guildName
        );
        
        require(IERC20(_depositToken).transferFrom(msg.sender, address(mystic), _summonerDeposit), "!transfer"); // transfer summoner deposit to new MYSTIC
        
        emit SummonMYSTIC(address(mystic), _depositToken, _stakeToken, _summoner, _summonerShares, _summonerDeposit, _proposalDeposit, _processingReward, _periodDuration, _votingPeriodLength, _gracePeriodLength, _dilutionBound, now);
        
        return address(mystic);
    }
}
