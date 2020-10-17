pragma solidity 0.6.12;

contract ReentrancyGuard { // call wrapper for reentrancy check
    bool private _notEntered;

    function _initReentrancyGuard () internal {
        _notEntered = true;
    }

    modifier nonReentrant() {
        require(_notEntered, "reentrant");

        _notEntered = false;

        _;

        _notEntered = true;
    }
}
