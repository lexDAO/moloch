pragma solidity 0.5.17;

interface ISummonMinion {
    function setMolochSummoner(address _molochSummoner) external;
    function summonMinion(address _moloch, address _molochApprovedToken) external;
}
