// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Aiki.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title AikiFactory
 * @dev Factory contract for deploying Aiki educational platform contracts.
 */
contract AikiFactory is Ownable {
  event PlatformCreated(address indexed platformAddress, address indexed owner, string name);
  event PlatformFeeUpdated(uint256 oldFee, uint256 newFee);

  uint256 public platformCreationFee = 0.01 ether;
  address public feeCollector;

  mapping(address => address[]) public deployedPlatforms;
  mapping(address => bool) public isPlatform;
  address[] public allPlatforms;

  constructor() Ownable(msg.sender) {
    feeCollector = msg.sender;
  }

  /**
   * @dev Create a new Aiki platform.
   * @param platformName Name of the educational platform.
   */
  function createPlatform(string memory platformName) external payable returns (address) {
    require(msg.value >= platformCreationFee, "Insufficient payment for platform creation");

    Aiki newPlatform = new Aiki();
    newPlatform.transferOwnership(msg.sender);

    (bool success,) = payable(feeCollector).call{ value: platformCreationFee }("");
    require(success, "Failed to send platform creation fee");

    uint256 refund = msg.value - platformCreationFee;
    if (refund > 0) {
      (bool refundSuccess,) = payable(msg.sender).call{ value: refund }("");
      require(refundSuccess, "Failed to refund excess payment");
    }

    address platformAddress = address(newPlatform);
    deployedPlatforms[msg.sender].push(platformAddress);
    isPlatform[platformAddress] = true;
    allPlatforms.push(platformAddress);

    emit PlatformCreated(platformAddress, msg.sender, platformName);
    return platformAddress;
  }

  /**
   * @dev Update the platform creation fee.
   * @param newFee New fee amount.
   */
  function updatePlatformCreationFee(uint256 newFee) external onlyOwner {
    uint256 oldFee = platformCreationFee;
    platformCreationFee = newFee;
    emit PlatformFeeUpdated(oldFee, newFee);
  }

  /**
   * @dev Update the fee collector address.
   * @param newCollector New fee collector address.
   */
  function updateFeeCollector(address newCollector) external onlyOwner {
    require(newCollector != address(0), "Invalid address");
    feeCollector = newCollector;
  }

  function getPlatformsByOwner(address owner) external view returns (address[] memory) {
    return deployedPlatforms[owner];
  }

  function getAllPlatforms() external view returns (address[] memory) {
    return allPlatforms;
  }

  function getPlatformCount() external view returns (uint256) {
    return allPlatforms.length;
  }

  function isPlatformDeployed(address platformAddress) external view returns (bool) {
    return isPlatform[platformAddress];
  }

  function withdraw() external onlyOwner {
    uint256 balance = address(this).balance;
    require(balance > 0, "No funds to withdraw");

    (bool success,) = payable(msg.sender).call{ value: balance }("");
    require(success, "Withdrawal failed");
  }
}
