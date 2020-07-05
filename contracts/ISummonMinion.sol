pragma solidity 0.5.17;

interface ISummonMinion { // brief interface for moloch minion summoning
    function setMolochSummoner(address molochSummoner) external;
    function summonMinion(address moloch, address molochDepositToken) external;
}
