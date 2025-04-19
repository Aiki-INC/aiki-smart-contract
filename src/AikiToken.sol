// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title AikiToken
 * @dev ERC20 token for the Educhain educational platform with learning rewards
 */
contract AikiToken is ERC20, ERC20Burnable, Ownable {
  // Constants
  uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10 ** 18; // 1 billion tokens

  // Reward parameters
  uint256 public courseCompletionReward = 50 * 10 ** 18; // 50 tokens per course completion
  uint256 public courseMilestoneReward = 5 * 10 ** 18; // 5 tokens per milestone
  uint256 public instructorRewardPerStudent = 10 * 10 ** 18; // 10 tokens per enrolled student

  // Addresses
  address public rewardPool;

  // Contract address registrations
  mapping(address => bool) public authorizedPlatforms;

  // Events
  event RewardIssued(address indexed recipient, uint256 amount, string rewardType);
  event PlatformAuthorized(address indexed platform, bool authorized);
  event RewardRateUpdated(string rewardType, uint256 oldRate, uint256 newRate);

  // Constructor
  constructor() ERC20("Educhain Token", "EDT") Ownable(msg.sender) {
    // Create a reward pool with initial supply
    _mint(msg.sender, MAX_SUPPLY / 2); // 50% to owner/initial distribution

    // Set up reward pool
    rewardPool = msg.sender;
  }

  // Modifiers
  modifier onlyAuthorizedPlatform() {
    require(authorizedPlatforms[msg.sender], "Caller is not an authorized platform");
    _;
  }

  /**
   * @dev Authorize a platform to distribute rewards
   * @param platform Address of the platform
   * @param authorized Authorization status
   */
  function authorizePlatform(address platform, bool authorized) external onlyOwner {
    require(platform != address(0), "Invalid platform address");
    authorizedPlatforms[platform] = authorized;

    emit PlatformAuthorized(platform, authorized);
  }

  /**
   * @dev Set the reward pool address
   * @param newRewardPool Address of the new reward pool
   */
  function setRewardPool(address newRewardPool) external onlyOwner {
    require(newRewardPool != address(0), "Invalid reward pool address");
    rewardPool = newRewardPool;
  }

  /**
   * @dev Issue rewards for course completion
   * @param student Address of the student who completed the course
   */
  function rewardCourseCompletion(address student) external onlyAuthorizedPlatform {
    require(student != address(0), "Invalid student address");

    uint256 rewardAmount = courseCompletionReward;
    _transferReward(student, rewardAmount, "course_completion");
  }

  /**
   * @dev Issue rewards for reaching a course milestone
   * @param student Address of the student who reached the milestone
   */
  function rewardCourseMilestone(address student) external onlyAuthorizedPlatform {
    require(student != address(0), "Invalid student address");

    uint256 rewardAmount = courseMilestoneReward;
    _transferReward(student, rewardAmount, "course_milestone");
  }

  /**
   * @dev Issue rewards to instructors for student enrollment
   * @param instructor Address of the instructor
   */
  function rewardInstructor(address instructor) external onlyAuthorizedPlatform {
    require(instructor != address(0), "Invalid instructor address");

    uint256 rewardAmount = instructorRewardPerStudent;
    _transferReward(instructor, rewardAmount, "instructor_reward");
  }

  /**
   * @dev Transfer tokens from reward pool to recipient
   * @param recipient Address of the reward recipient
   * @param amount Amount of tokens to transfer
   * @param rewardType Type of reward being issued
   */
  function _transferReward(address recipient, uint256 amount, string memory rewardType) private {
    require(balanceOf(rewardPool) >= amount, "Insufficient reward pool balance");

    // Transfer tokens from reward pool to recipient
    _transfer(rewardPool, recipient, amount);

    emit RewardIssued(recipient, amount, rewardType);
  }

  /**
   * @dev Update course completion reward
   * @param newRate New reward rate
   */
  function updateCourseCompletionReward(uint256 newRate) external onlyOwner {
    uint256 oldRate = courseCompletionReward;
    courseCompletionReward = newRate;

    emit RewardRateUpdated("course_completion", oldRate, newRate);
  }

  /**
   * @dev Update course milestone reward
   * @param newRate New reward rate
   */
  function updateCourseMilestoneReward(uint256 newRate) external onlyOwner {
    uint256 oldRate = courseMilestoneReward;
    courseMilestoneReward = newRate;

    emit RewardRateUpdated("course_milestone", oldRate, newRate);
  }

  /**
   * @dev Update instructor reward per student
   * @param newRate New reward rate
   */
  function updateInstructorReward(uint256 newRate) external onlyOwner {
    uint256 oldRate = instructorRewardPerStudent;
    instructorRewardPerStudent = newRate;

    emit RewardRateUpdated("instructor_reward", oldRate, newRate);
  }

  /**
   * @dev Transfer tokens from owner's account to multiple recipients
   * @param recipients Array of recipient addresses
   * @param amounts Array of amounts to transfer
   */
  function multiTransfer(address[] calldata recipients, uint256[] calldata amounts)
    external
    onlyOwner
  {
    require(recipients.length == amounts.length, "Arrays length mismatch");

    for (uint256 i = 0; i < recipients.length; i++) {
      require(recipients[i] != address(0), "Invalid recipient address");
      _transfer(msg.sender, recipients[i], amounts[i]);
    }
  }

  /**
   * @dev Fund the reward pool
   * @param amount Amount of tokens to add to the reward pool
   */
  function fundRewardPool(uint256 amount) external {
    require(amount > 0, "Amount must be greater than 0");
    require(balanceOf(msg.sender) >= amount, "Insufficient balance");

    _transfer(msg.sender, rewardPool, amount);
  }
}
