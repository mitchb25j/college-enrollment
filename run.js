const { ethers } = require("hardhat");

const main = async () => {
  const CSEnrollment = await ethers.getContractFactory("CSEnrollment");
  const enrollment = await CSEnrollment.deploy();
  await enrollment.deployed();
  console.log("Enrollment contract deployed to:", enrollment.address);

  // Register a student successfully
  await enrollment.register(30, "graduate", 617);
  console.log("Student registered successfully");

  // Register an undergraduate for a graduate course
  try {
    await enrollment.register(25, "undergraduate", 670);
  } catch (error) {
    console.log("Error registering student:", error.message);
  }

  // Add a new course successfully
  await enrollment.add(666, "undergraduate");
  console.log("New course added successfully");

  // Attempt to add a course that already exists
  try {
    await enrollment.add(617, "graduate");
  } catch (error) {
    console.log("Error adding course:", error.message);
  }

  // Get the roster for a course with 0 students
  const roster484 = await enrollment.getRoster(484);
  console.log("Roster for course 484:", roster484);

  // Register multiple students for a course
  await enrollment.register(40, "graduate", 617);
  await enrollment.register(50, "graduate", 617);

  // Get the roster for a course with multiple students
  const roster617 = await enrollment.getRoster(617);
  console.log("Roster for course 617:", roster617);

  // Get the roster for a course that does not exist
  try {
    await enrollment.getRoster(999);
  } catch (error) {
    console.log("Error getting roster:", error.message);
  }
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

runMain();
