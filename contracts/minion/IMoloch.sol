pragma solidity 0.5.17;

interface IMoloch { // brief interface for minion txs to parent moloch
    function getProposalFlags(uint256 proposalId) external view returns (bool[6] memory);

    function submitProposal(
        address applicant,
        uint256 sharesRequested,
        uint256 lootRequested,
        uint256 tributeOffered,
        address tributeToken,
        uint256 paymentRequested,
        address paymentToken,
        bytes32 details
    ) external returns (uint256);
    
    function withdrawBalance(address token, uint256 amount) external;
}
