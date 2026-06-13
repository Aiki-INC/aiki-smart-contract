// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Test, console } from "forge-std/Test.sol";
import { Aiki } from "../src/Aiki.sol";

contract AikiTest is Test {
  Aiki public platform;
  address public admin = address(1);
  address public instructor = address(2);
  address public student = address(3);
  address public feeCollector = address(4);
  uint256 public courseId;

  // Constants for testing
  uint256 constant COURSE_PRICE = 0.1 ether;
  uint256 constant PLATFORM_FEE = 0.001 ether;
  uint256 constant COURSE_DURATION = 30 days;

  function setUp() public {
    vm.startPrank(admin);
    platform = new Aiki();
    platform.updateFeeCollector(feeCollector);
    vm.stopPrank();

    // Register instructor
    vm.prank(instructor);
    platform.registerAsInstructor();

    // Create a base course for common tests
    string memory contentURI = "ipfs://QmBase";
    vm.prank(instructor);
    courseId = platform.createCourse(
      "Base Course", "Base Course Description", COURSE_PRICE, COURSE_DURATION, contentURI
    );
  }

  // ============= Instructor Tests =============
  function testRegisterAsInstructor() public {
    address newInstructor = address(10);

    vm.prank(newInstructor);
    platform.registerAsInstructor();

    assertTrue(platform.instructors(newInstructor));
  }

  function testCannotRegisterTwice() public {
    vm.prank(instructor);
    vm.expectRevert("Already registered as instructor");
    platform.registerAsInstructor();
  }

  // ============= Course Tests =============
  function testCreateCourse() public {
    string memory title = "New Course";
    string memory description = "New Course Description";
    uint256 price = 0.2 ether;
    uint256 duration = 60 days;
    string memory contentURI = "ipfs://QmNewCourse";

    vm.prank(instructor);
    uint256 newCourseId = platform.createCourse(title, description, price, duration, contentURI);

    (
      uint256 id,
      address courseInstructor,
      string memory courseTitle,
      string memory courseDescription,
      uint256 coursePrice,
      bool isActive,,,
    ) = platform.courses(newCourseId);

    assertEq(id, newCourseId);
    assertEq(courseInstructor, instructor);
    assertEq(courseTitle, title);
    assertEq(courseDescription, description);
    assertEq(coursePrice, price);
    assertTrue(isActive);
  }

  function testNonInstructorCannotCreateCourse() public {
    vm.prank(student);
    vm.expectRevert("Only instructors can call this function");
    platform.createCourse("Test", "Test", 0.1 ether, 30 days, "ipfs://test");
  }

  function testUpdateCourse() public {
    string memory newTitle = "Updated Course";
    string memory newDescription = "Updated Description";
    uint256 newPrice = 0.15 ether;
    bool newActive = false;
    string memory newContentURI = "ipfs://QmUpdated";

    vm.prank(instructor);
    platform.updateCourse(courseId, newTitle, newDescription, newPrice, newActive, newContentURI);

    (
      ,,
      string memory courseTitle,
      string memory courseDescription,
      uint256 coursePrice,
      bool isActive,,,
    ) = platform.courses(courseId);

    assertEq(courseTitle, newTitle);
    assertEq(courseDescription, newDescription);
    assertEq(coursePrice, newPrice);
    assertEq(isActive, newActive);
  }

  function testOnlyCourseInstructorCanUpdate() public {
    vm.prank(student);
    vm.expectRevert("Only the course instructor can call this function");
    platform.updateCourse(courseId, "Test", "Test", 0.1 ether, true, "ipfs://test");
  }

  // ============= Enrollment Tests =============
  function testEnrollInCourse() public {
    vm.deal(student, 1 ether);

    vm.prank(student);
    platform.enrollInCourse{ value: COURSE_PRICE + PLATFORM_FEE }(courseId);

    (uint256 enrolledCourseId, address enrolledStudent,,, bool isCompleted, uint256 progress) =
      platform.enrollments(courseId, student);

    assertEq(enrolledCourseId, courseId);
    assertEq(enrolledStudent, student);
    assertFalse(isCompleted);
    assertEq(progress, 0);

    // Check instructor received payment
    assertEq(instructor.balance, COURSE_PRICE);

    // Check platform fee collection
    assertEq(feeCollector.balance, PLATFORM_FEE);
  }

  function testEnrollWithRefund() public {
    vm.deal(student, 1 ether);
    uint256 overpayment = 0.05 ether;
    uint256 initialBalance = student.balance;

    vm.prank(student);
    platform.enrollInCourse{ value: COURSE_PRICE + PLATFORM_FEE + overpayment }(courseId);

    // Verify refund
    assertEq(student.balance, initialBalance - COURSE_PRICE - PLATFORM_FEE);
  }

  function testCannotEnrollWithoutSufficientPayment() public {
    vm.deal(student, 1 ether);

    vm.prank(student);
    vm.expectRevert("Insufficient payment");
    platform.enrollInCourse{ value: COURSE_PRICE }(courseId);
  }

  function testCannotEnrollTwice() public {
    vm.deal(student, 2 ether);

    vm.prank(student);
    platform.enrollInCourse{ value: COURSE_PRICE + PLATFORM_FEE }(courseId);

    vm.prank(student);
    vm.expectRevert("Already enrolled in this course");
    platform.enrollInCourse{ value: COURSE_PRICE + PLATFORM_FEE }(courseId);
  }

  function testInstructorCannotEnrollInOwnCourse() public {
    vm.deal(instructor, 1 ether);

    vm.prank(instructor);
    vm.expectRevert("Instructors cannot enroll in their own courses");
    platform.enrollInCourse{ value: COURSE_PRICE + PLATFORM_FEE }(courseId);
  }

  // ============= Progress Tests =============
  function testUpdateProgress() public {
    // First enroll
    vm.deal(student, 1 ether);
    vm.prank(student);
    platform.enrollInCourse{ value: COURSE_PRICE + PLATFORM_FEE }(courseId);

    // Update progress
    uint256 newProgress = 50;
    vm.prank(student);
    platform.updateProgress(courseId, newProgress);

    (,,,,, uint256 progress) = platform.enrollments(courseId, student);
    assertEq(progress, newProgress);
  }

  function testUpdateProgressToCompletion() public {
    // First enroll
    vm.deal(student, 1 ether);
    vm.prank(student);
    platform.enrollInCourse{ value: COURSE_PRICE + PLATFORM_FEE }(courseId);

    // Complete the course
    vm.prank(student);
    platform.updateProgress(courseId, 100);

    (,,,, bool isCompleted, uint256 progress) = platform.enrollments(courseId, student);
    assertTrue(isCompleted);
    assertEq(progress, 100);
  }

  function testCannotUpdateProgressIfNotEnrolled() public {
    vm.prank(student);
    vm.expectRevert("Student is not enrolled in this course");
    platform.updateProgress(courseId, 50);
  }

  function testCannotSetProgressAbove100() public {
    // First enroll
    vm.deal(student, 1 ether);
    vm.prank(student);
    platform.enrollInCourse{ value: COURSE_PRICE + PLATFORM_FEE }(courseId);

    // Try to set progress too high
    vm.prank(student);
    vm.expectRevert("Progress must be between 0 and 100");
    platform.updateProgress(courseId, 101);
  }

  // ============= Certificate Tests =============
  function testIssueCertificate() public {
    // Enroll and complete course
    vm.deal(student, 1 ether);
    vm.prank(student);
    platform.enrollInCourse{ value: COURSE_PRICE + PLATFORM_FEE }(courseId);

    vm.prank(student);
    platform.updateProgress(courseId, 100);

    // Issue certificate
    string memory metadataURI = "ipfs://QmCertificate";
    vm.prank(instructor);
    platform.issueCertificate(courseId, student, metadataURI);

    // Check certificate was issued
    (uint256 certId, uint256 certCourseId, address recipient,, string memory certURI) =
      platform.certificates(1);

    assertEq(certId, 1);
    assertEq(certCourseId, courseId);
    assertEq(recipient, student);
    assertEq(certURI, metadataURI);

    // Check NFT ownership
    assertEq(platform.ownerOf(1), student);
    assertEq(platform.tokenURI(1), metadataURI);
  }

  function testCannotIssueCertificateForIncompleteStudent() public {
    // Enroll but don't complete
    vm.deal(student, 1 ether);
    vm.prank(student);
    platform.enrollInCourse{ value: COURSE_PRICE + PLATFORM_FEE }(courseId);

    // Try to issue certificate
    vm.prank(instructor);
    vm.expectRevert("Course is not completed");
    platform.issueCertificate(courseId, student, "ipfs://test");
  }

  function testVerifyCertificate() public {
    // Enroll and complete course
    vm.deal(student, 1 ether);
    vm.prank(student);
    platform.enrollInCourse{ value: COURSE_PRICE + PLATFORM_FEE }(courseId);

    vm.prank(student);
    platform.updateProgress(courseId, 100);

    // Issue certificate
    vm.prank(instructor);
    platform.issueCertificate(courseId, student, "ipfs://QmCertificate");

    // Verify certificate
    bool isValid = platform.verifyCertificate(1, student);
    assertTrue(isValid);

    // Non-owner should not verify
    bool isInvalid = platform.verifyCertificate(1, instructor);
    assertFalse(isInvalid);
  }

  // ============= Admin/Owner Tests =============
  function testUpdatePlatformFee() public {
    uint256 newFee = 0.002 ether;

    vm.prank(admin);
    platform.updatePlatformFee(newFee);

    assertEq(platform.platformFee(), newFee);
  }

  function testUpdateFeeCollector() public {
    address newCollector = address(20);

    vm.prank(admin);
    platform.updateFeeCollector(newCollector);

    assertEq(platform.feeCollector(), newCollector);
  }

  function testNonOwnerCannotUpdateFee() public {
    vm.prank(instructor);
    vm.expectRevert(); // Ownable reverts with a generic message
    platform.updatePlatformFee(0.5 ether);
  }

  // ============= Getter Methods Tests =============
  function testGetStudentEnrollments() public {
    // Enroll in a course
    vm.deal(student, 2 ether);
    vm.prank(student);
    platform.enrollInCourse{ value: COURSE_PRICE + PLATFORM_FEE }(courseId);

    // Create another course and enroll
    vm.prank(instructor);
    uint256 secondCourseId = platform.createCourse(
      "Second Course", "Description", COURSE_PRICE, COURSE_DURATION, "ipfs://Qm2"
    );

    vm.prank(student);
    platform.enrollInCourse{ value: COURSE_PRICE + PLATFORM_FEE }(secondCourseId);

    // Get enrollments
    uint256[] memory enrollments = platform.getStudentEnrollments(student);

    assertEq(enrollments.length, 2);
    assertEq(enrollments[0], courseId);
    assertEq(enrollments[1], secondCourseId);
  }

  function testGetInstructorCourses() public {
    // Create second course
    vm.prank(instructor);
    uint256 secondCourseId = platform.createCourse(
      "Second Course", "Description", COURSE_PRICE, COURSE_DURATION, "ipfs://Qm2"
    );

    // Get instructor courses
    uint256[] memory courses = platform.getInstructorCourses(instructor);

    assertEq(courses.length, 2);
    assertEq(courses[0], courseId);
    assertEq(courses[1], secondCourseId);
  }

  function testGetUserCertificates() public {
    // Setup certificate
    vm.deal(student, 1 ether);

    vm.prank(student);
    platform.enrollInCourse{ value: COURSE_PRICE + PLATFORM_FEE }(courseId);

    vm.prank(student);
    platform.updateProgress(courseId, 100);

    vm.prank(instructor);
    platform.issueCertificate(courseId, student, "ipfs://QmCert");

    // Get certificates
    uint256[] memory certificates = platform.getUserCertificates(student);

    assertEq(certificates.length, 1);
    assertEq(certificates[0], 1);
  }
}

