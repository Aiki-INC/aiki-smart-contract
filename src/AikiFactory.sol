// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Aiki.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title AikichainFactory
 * @dev A factory contract for deploying Educhain educational platforms
 */
contract AikiFactory is Ownable {
  // Events
  event PlatformCreated(address indexed platformAddress, address indexed owner, string name);
  event PlatformFeeUpdated(uint256 oldFee, uint256 newFee);

  // State variables
  uint256 public platformCreationFee = 0.01 ether;
  address public feeCollector;

  // Mapping of all deployed platforms
  mapping(address => address[]) public deployedPlatforms;
  mapping(address => bool) public isPlatform;
  address[] public allPlatforms;

  // Constructor
  constructor() Ownable(msg.sender) {
    feeCollector = msg.sender;
  }

  /**
   * @dev Create a new Educhain platform
   * @param platformName Name of the educational platform
   */
  function createPlatform(string memory platformName) external payable returns (address) {
    require(msg.value >= platformCreationFee, "Insufficient payment for platform creation");

    // Create new platform
    Aiki newPlatform = new Aiki();

    // Transfer ownership to the creator
    newPlatform.transferOwnership(msg.sender);

    // Handle the creation fee
    (bool success,) = payable(feeCollector).call{ value: platformCreationFee }("");
    require(success, "Failed to send platform creation fee");

    // Refund excess payment if any
    uint256 refund = msg.value - platformCreationFee;
    if (refund > 0) {
      (bool refundSuccess,) = payable(msg.sender).call{ value: refund }("");
      require(refundSuccess, "Failed to refund excess payment");
    }

    // Track the deployed platform
    address platformAddress = address(newPlatform);
    deployedPlatforms[msg.sender].push(platformAddress);
    isPlatform[platformAddress] = true;
    allPlatforms.push(platformAddress);

    emit PlatformCreated(platformAddress, msg.sender, platformName);

    return platformAddress;
  }

  /**
   * @dev Update the platform creation fee
   * @param newFee New fee amount
   */
  function updatePlatformCreationFee(uint256 newFee) external onlyOwner {
    uint256 oldFee = platformCreationFee;
    platformCreationFee = newFee;

    emit PlatformFeeUpdated(oldFee, newFee);
  }

  /**
   * @dev Update the fee collector address
   * @param newCollector New fee collector address
   */
  function updateFeeCollector(address newCollector) external onlyOwner {
    require(newCollector != address(0), "Invalid address");
    feeCollector = newCollector;
  }

  /**
   * @dev Get all platforms deployed by a specific owner
   * @param owner Address of the platform owner
   */
  function getPlatformsByOwner(address owner) external view returns (address[] memory) {
    return deployedPlatforms[owner];
  }

  /**
   * @dev Get all deployed platforms
   */
  function getAllPlatforms() external view returns (address[] memory) {
    return allPlatforms;
  }

  /**
   * @dev Get the total number of deployed platforms
   */
  function getPlatformCount() external view returns (uint256) {
    return allPlatforms.length;
  }

  /**
   * @dev Check if an address is a deployed platform
   * @param platformAddress Address to check
   */
  function isPlatformDeployed(address platformAddress) external view returns (bool) {
    return isPlatform[platformAddress];
  }

  /**
   * @dev Withdraw funds from the contract (only owner)
   */
  function withdraw() external onlyOwner {
    uint256 balance = address(this).balance;
    require(balance > 0, "No funds to withdraw");

    (bool success,) = payable(msg.sender).call{ value: balance }("");
    require(success, "Withdrawal failed");
  }
}
