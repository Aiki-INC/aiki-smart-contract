// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

/**
 * @title Aiki
 * @dev A smart contract for managing an educational platform on Arbitrum L3
 */
contract Aiki is ERC721URIStorage, Ownable {
  // Counters for generating unique IDs (updated for OpenZeppelin 5.x)
  uint256 private _nextCourseId = 0;
  uint256 private _nextCertificateId = 0;

  // Fee configuration
  uint256 public platformFee = 0.001 ether; // platform fee
  address public feeCollector;

  // enum ContentType {
  //     TEXT,
  //     IMAGE,
  //     VIDEO
  // }

  // Structs
  struct Course {
    uint256 id;
    address instructor;
    string title;
    string description;
    uint256 price;
    bool isActive;
    uint256 duration; // in seconds
    uint256 enrollmentCount;
    string contentURI; // IPFS URI containing course content metadata
  }

  struct Enrollment {
    uint256 courseId;
    address student;
    uint256 enrollmentDate;
    uint256 expiryDate;
    bool isCompleted;
    uint256 progress; // 0-100 percentage
  }

  struct Certificate {
    uint256 id;
    uint256 courseId;
    address recipient;
    uint256 issueDate;
    string metadataURI; // IPFS URI containing certificate metadata
  }

  // Mappings
  mapping(uint256 => Course) public courses;
  mapping(uint256 => mapping(address => Enrollment)) public enrollments;
  mapping(address => uint256[]) public instructorCourses;
  mapping(address => uint256[]) public studentEnrollments;
  mapping(address => bool) public instructors;
  mapping(uint256 => Certificate) public certificates;
  mapping(address => uint256[]) public userCertificates;

  // Events
  event CourseCreated(
    uint256 indexed courseId, address indexed instructor, string title, uint256 price
  );
  event CourseUpdated(uint256 indexed courseId, string title, uint256 price, bool isActive);
  event CourseEnrollment(
    uint256 indexed courseId, address indexed student, uint256 enrollmentDate, uint256 expiryDate
  );
  event CourseProgressUpdated(uint256 indexed courseId, address indexed student, uint256 progress);
  event CourseCompleted(uint256 indexed courseId, address indexed student);
  event CertificateIssued(
    uint256 indexed certificateId, uint256 indexed courseId, address indexed recipient
  );
  event InstructorRegistered(address indexed instructor);
  event PlatformFeeUpdated(uint256 oldFee, uint256 newFee);

  // Constructor
  constructor() ERC721("Educhain Certificate", "EDC") Ownable(msg.sender) {
    feeCollector = msg.sender;
  }

  // Modifiers
  modifier onlyInstructor() {
    require(instructors[msg.sender], "Only instructors can call this function");
    _;
  }

  modifier courseExists(uint256 courseId) {
    require(courses[courseId].instructor != address(0), "Course does not exist");
    _;
  }

  modifier onlyCourseInstructor(uint256 courseId) {
    require(
      courses[courseId].instructor == msg.sender,
      "Only the course instructor can call this function"
    );
    _;
  }

  modifier isEnrolled(uint256 courseId) {
    require(
      enrollments[courseId][msg.sender].student == msg.sender,
      "Student is not enrolled in this course"
    );
    _;
  }

  // External functions

  /**
   * @dev Register as an instructor
   */
  function registerAsInstructor() external {
    require(!instructors[msg.sender], "Already registered as instructor");
    instructors[msg.sender] = true;

    emit InstructorRegistered(msg.sender);
  }

  /**
   * @dev Create a new course (only instructors)
   */
  function createCourse(
    string calldata title,
    string calldata description,
    uint256 price,
    uint256 duration,
    string calldata contentURI
  ) external onlyInstructor returns (uint256) {
    uint256 courseId = _nextCourseId++;

    courses[courseId] = Course({
      id: courseId,
      instructor: msg.sender,
      title: title,
      description: description,
      price: price,
      isActive: true,
      duration: duration,
      enrollmentCount: 0,
      contentURI: contentURI
    });

    instructorCourses[msg.sender].push(courseId);

    emit CourseCreated(courseId, msg.sender, title, price);

    return courseId;
  }

  /**
   * @dev Update an existing course (only course instructor)
   */
  function updateCourse(
    uint256 courseId,
    string calldata title,
    string calldata description,
    uint256 price,
    bool isActive,
    string calldata contentURI
  ) external courseExists(courseId) onlyCourseInstructor(courseId) {
    Course storage course = courses[courseId];

    course.title = title;
    course.description = description;
    course.price = price;
    course.isActive = isActive;
    course.contentURI = contentURI;

    emit CourseUpdated(courseId, title, price, isActive);
  }

  /**
   * @dev Enroll in a course
   */
  function enrollInCourse(uint256 courseId) external payable courseExists(courseId) {
    Course storage course = courses[courseId];

    require(course.isActive, "Course is not active");
    require(course.instructor != msg.sender, "Instructors cannot enroll in their own courses");
    require(
      enrollments[courseId][msg.sender].student == address(0), "Already enrolled in this course"
    );
    require(msg.value >= course.price + platformFee, "Insufficient payment");

    // Calculate payment distribution
    uint256 instructorPayment = course.price;
    uint256 platformPayment = platformFee;
    uint256 refund = msg.value - (instructorPayment + platformPayment);

    // Handle payments
    (bool successInstructor,) = payable(course.instructor).call{ value: instructorPayment }("");
    require(successInstructor, "Failed to send payment to instructor");

    (bool successPlatform,) = payable(feeCollector).call{ value: platformPayment }("");
    require(successPlatform, "Failed to send platform fee");

    // Refund excess payment if any
    if (refund > 0) {
      (bool successRefund,) = payable(msg.sender).call{ value: refund }("");
      require(successRefund, "Failed to refund excess payment");
    }

    // Create enrollment
    uint256 enrollmentDate = block.timestamp;
    uint256 expiryDate = enrollmentDate + course.duration;

    enrollments[courseId][msg.sender] = Enrollment({
      courseId: courseId,
      student: msg.sender,
      enrollmentDate: enrollmentDate,
      expiryDate: expiryDate,
      isCompleted: false,
      progress: 0
    });

    studentEnrollments[msg.sender].push(courseId);
    course.enrollmentCount++;

    emit CourseEnrollment(courseId, msg.sender, enrollmentDate, expiryDate);
  }

  /**
   * @dev Update course progress
   */
  function updateProgress(uint256 courseId, uint256 progress)
    external
    courseExists(courseId)
    isEnrolled(courseId)
  {
    require(progress <= 100, "Progress must be between 0 and 100");

    Enrollment storage enrollment = enrollments[courseId][msg.sender];
    enrollment.progress = progress;

    if (progress == 100 && !enrollment.isCompleted) {
      enrollment.isCompleted = true;
      emit CourseCompleted(courseId, msg.sender);
    }

    emit CourseProgressUpdated(courseId, msg.sender, progress);
  }

  /**
   * @dev Issue certificate for course completion
   */
  function issueCertificate(uint256 courseId, address student, string calldata metadataURI)
    external
    courseExists(courseId)
    onlyCourseInstructor(courseId)
  {
    require(
      enrollments[courseId][student].student == student, "Student is not enrolled in this course"
    );
    require(enrollments[courseId][student].isCompleted, "Course is not completed");

    _nextCertificateId++;
    uint256 certificateId = _nextCertificateId;

    certificates[certificateId] = Certificate({
      id: certificateId,
      courseId: courseId,
      recipient: student,
      issueDate: block.timestamp,
      metadataURI: metadataURI
    });

    userCertificates[student].push(certificateId);

    // Mint certificate as NFT
    _mint(student, certificateId);
    _setTokenURI(certificateId, metadataURI);

    emit CertificateIssued(certificateId, courseId, student);
  }

  /**
   * @dev Get student's enrolled courses
   */
  function getStudentEnrollments(address student) external view returns (uint256[] memory) {
    return studentEnrollments[student];
  }

  /**
   * @dev Get instructor's courses
   */
  function getInstructorCourses(address instructor) external view returns (uint256[] memory) {
    return instructorCourses[instructor];
  }

  /**
   * @dev Get user's certificates
   */
  function getUserCertificates(address user) external view returns (uint256[] memory) {
    return userCertificates[user];
  }

  /**
   * @dev Update platform fee (only owner)
   */
  function updatePlatformFee(uint256 newFee) external onlyOwner {
    uint256 oldFee = platformFee;
    platformFee = newFee;

    emit PlatformFeeUpdated(oldFee, newFee);
  }

  /**
   * @dev Update fee collector address (only owner)
   */
  function updateFeeCollector(address newCollector) external onlyOwner {
    require(newCollector != address(0), "Invalid address");
    feeCollector = newCollector;
  }

  /**
   * @dev Function to check if a token ID exists
   */
  function _exists(uint256 tokenId) internal view returns (bool) {
    return _ownerOf(tokenId) != address(0);
  }

  /**
   * @dev Check if a certificate is valid
   */
  function verifyCertificate(uint256 certificateId, address recipient)
    external
    view
    returns (bool)
  {
    return certificates[certificateId].recipient == recipient && _exists(certificateId);
  }
}
