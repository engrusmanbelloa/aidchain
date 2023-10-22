pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {Governance} from "../src/Governance.sol";
import {UserOnboarding} from "../src/Onboarding.sol";

contract GovernanceTest is Test {
    Governance governance;

    function setUp() public {
        // Us trying to tell OnboardingTests to call UserOnboarding for us.
        governance = new Governance();
        governance.registerUser(address(this));
    }

    function test_ProposeProgram() public {
        string memory description = "Education Support";
        uint256 startTime = block.timestamp + 3600;
        uint256 endTime = startTime + 604800;

        uint256 initialProgramCount = governance.getProgramProposalCount();
        governance.proposeProgram(description, startTime, endTime);
        uint256 newProgramCount = governance.getProgramProposalCount();

        assertEq(
            newProgramCount,
            initialProgramCount + 1,
            "Program count should increase by 1"
        );
    }

    function test_ProposeAndVote() public {
        // Calculate start time and end time
        uint256 startTime = block.timestamp + 1; // Start in 1 minute
        uint256 endTime = startTime + 604800; // End in 2 days

        governance.proposeProgram("Test Proposal", startTime, endTime);

        // Vote for the proposal
        bool isSupported = true;
        governance.voteOnProposal(0, isSupported);

        // Check the vote count for the proposal
        (, , , uint256 votesFor, , , ) = governance.getProposal(0);
        assertEq(votesFor, 1, "Votes for proposal should be 1");
    }
}
