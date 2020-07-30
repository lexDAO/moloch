pragma solidity 0.5.17;

interface IWETH { // brief interface for ether wrapper contract 
    function deposit() payable external;
    
    function transfer(address dst, uint wad) external returns (bool);
}
