pragma solidity 0.6.12;

interface IWETH { // brief interface for canonical ether token wrapper 
    function deposit() external payable;
    
    function transfer(address dst, uint wad) external returns (bool);
}
