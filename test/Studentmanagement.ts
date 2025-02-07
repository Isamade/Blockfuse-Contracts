import {
    time,
    loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";

describe("StudentManagement", function () {
    async function deployStudentManagement() {
        const [owner, account1, account2] = await hre.ethers.getSigners();

        const StudentManagement = await hre.ethers.getContractFactory("StudentManagement");
        const studentManagement = await StudentManagement.deploy();

        return { studentManagement, owner, account1, account2 };
    }

    describe("Students", function () {
        it("Should get all the students", async function () {
            const { studentManagement } = await loadFixture(deployStudentManagement);

            await studentManagement.registerStudent("Alice", 12, 'JSS2', 1);
            await studentManagement.registerStudent("Bob", 13, 'JSS3', 0);

            const students = await studentManagement.getStudents();
            expect(students.length).to.equal(2);
            expect(students[0].name).to.equal("Alice");
            expect(students[1].name).to.equal("Bob");
            expect(students[0].age).to.equal(12);
            expect(students[1].age).to.equal(13);
            expect(students[0].class).to.equal('JSS2');
            expect(students[1].class).to.equal('JSS3');
            expect(students[0].gender).to.equal(1);
            expect(students[1].gender).to.equal(0);

            //expect(await studentManagement.owner()).to.equal(owner.address);
        });
    });
});