pragma solidity 0.5.17;

interface IWETH { // brief interface for canonical ether token wrapper contract 
    function deposit() payable external;
    
    function transfer(address dst, uint wad) external returns (bool);
}
