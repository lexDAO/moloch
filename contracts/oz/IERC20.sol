pragma solidity 0.5.17;

interface IERC20 { // brief interface for Moloch DAO token txs
    function balanceOf(address who) external view returns (uint256);
    
    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);
}
