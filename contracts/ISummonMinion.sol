pragma solidity 0.5.17;

interface ISummonMinion {
    function setMolochSummoner(address molochSummoner) external;
    function summonMinion(address moloch, address molochDepositToken) external;
}
