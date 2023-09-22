// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CSEnrollment {
    enum EnrollmentType { UNDERGRADUATE, GRADUATE }

    struct Course {
        uint256 number;
        EnrollmentType courseType;
        bool gradsCanEnroll;
        bool exists;
    }

    struct Registered {
        address id;
        uint256 courseNum;
        uint256 timestamp; // only need for bonus
        uint256 credits;
        bool exists;
    }

    struct Student {
        address id;
        uint256 credits;
        bool exists;
    }

    mapping (address => Student) public students;
    mapping (uint256 => Course) public courses;
    mapping (uint256 => Registered) public enrollments;
    mapping (uint256 => uint256) public enrollmentCount;

    address public owner;

    constructor() {
        owner = msg.sender;
        courses[670] = Course(670, EnrollmentType.GRADUATE, true, true);
        courses[617] = Course(617, EnrollmentType.GRADUATE, true, true);
        courses[484] = Course(484, EnrollmentType.UNDERGRADUATE, true, true);
        courses[489] = Course(489, EnrollmentType.UNDERGRADUATE, false, true);
    }

    function register(uint256 credits, EnrollmentType studentType, uint256 courseNum) public {
        require(enrollmentCount[courseNum] < 30, "ERROR: Course is full.");
        require(enrollments[msg.sender].exists == false, "ERROR: Student already enrolled.");
        require(students[msg.sender].credits >= credits, "ERROR: Not enough credits.");
        require((studentType == EnrollmentType.GRADUATE && credits > 20) || studentType == EnrollmentType.UNDERGRADUATE, "ERROR: Invalid student type or credits.");
        require(courses[courseNum].exists == true, "ERROR: Course does not exist.");
        require(courses[courseNum].courseType == studentType, "ERROR: Invalid student type for course.");
        require(courses[courseNum].gradsCanEnroll || studentType == EnrollmentType.UNDERGRADUATE, "ERROR: Graduate students cannot enroll in this course.");

        enrollments[msg.sender] = Registered(msg.sender, courseNum, block.timestamp, credits, true);
        enrollmentCount[courseNum]++;
    }

    function add(uint256 courseNum, EnrollmentType courseType) public {
        require(msg.sender == owner, "ERROR: Only the owner can add courses.");
        require(courses[courseNum].exists == false, "ERROR: Course already exists.");

        bool gradsCanEnroll = true;
        if (courseType == EnrollmentType.UNDERGRADUATE && (courseNum == 484 || courseNum == 489)) {
            gradsCanEnroll = false;
        }

        courses[courseNum] = Course(courseNum, courseType, gradsCanEnroll, true);
    }

    function getRoster(uint256 courseNum) public view returns (address[] memory) {
        address[] memory roster = new address[](enrollmentCount[courseNum]);
        uint256 index = 0;

        for (uint256 i = 0; i < enrollmentCount[courseNum]; i++) {
            if (enrollments[i].courseNum == courseNum) {
                roster[index] = enrollments[i].id;
                index++;
            }
        }

        return roster;
    }
}
