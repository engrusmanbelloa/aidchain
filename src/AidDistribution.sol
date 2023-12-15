// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Donation.sol";

contract AidDistribution is Donation {
    // Mapping to track aid distributions for each program
    mapping(uint256 => DistributionRecord[]) private programDistributions;

    // Events
    event AidDistributed(address indexed beneficiary, string programName, uint256 amount);

    // Struct to hold aid distribution records
    struct DistributionRecord {
        address beneficiary;
        uint256 amount;
        uint256 timestamp;
    }

    constructor(address _celoTokenAddress) Donation(_celoTokenAddress) {}

    // Function to distribute aid to beneficiaries based on predefined criteria
    function distributeAid(uint256 _programIndex) public onlyOwner {
        require(_programIndex < donationOptions.length, "Invalid program index");

        DonationOption storage chosenOption = donationOptions[_programIndex];

        // Check if the program has ended
        require(block.timestamp > chosenOption.endTime, "Program not ended");

        // Get the number of beneficiaries from the applicants of the program
        address[] memory applicants = getApplicantsForProgram(_programIndex);
        uint256 numberOfBeneficiaries = applicants.length;

        // Calculate the total available aid for distribution
        uint256 totalAvailableAid = chosenOption.totalFunded;

        // Calculate the aid amount to distribute per beneficiary
        uint256 aidPerBeneficiary = totalAvailableAid / numberOfBeneficiaries;

        // Distribute aid to beneficiaries
        for (uint256 i = 0; i < numberOfBeneficiaries; i++) {
            address beneficiary = applicants[i];
            programDistributions[_programIndex].push(
                DistributionRecord({beneficiary: beneficiary, amount: aidPerBeneficiary, timestamp: block.timestamp})
            );

            // Transfer aid amount to the beneficiary
            cUSD.transfer(beneficiary, aidPerBeneficiary);

            emit AidDistributed(beneficiary, chosenOption.name, aidPerBeneficiary);
        }
    }

    // Function to get the distribution records for a specific program
    function getDistributionRecords(uint256 _programIndex) external view returns (DistributionRecord[] memory) {
        require(_programIndex < donationOptions.length, "Invalid program index");
        return programDistributions[_programIndex];
    }

    // Function to check if a User is a beneficiary of a specific program
    function isBeneficiaryOfProgram(address _user, uint256 _programIndex) external view returns (bool) {
        require(_programIndex < donationOptions.length, "Invalid program index");

        address[] storage beneficiaries = programApplicants[_programIndex];
        for (uint256 i = 0; i < beneficiaries.length; i++) {
            if (beneficiaries[i] == _user) {
                return true;
            }
        }
        return false;
    }

    // Function to check if a User has ever benefited before
    function hasEverBenefited(address _user) external view returns (bool) {
        for (uint256 i = 0; i < donationOptions.length; i++) {
            address[] storage beneficiaries = programApplicants[i];
            for (uint256 j = 0; j < beneficiaries.length; j++) {
                if (beneficiaries[j] == _user) {
                    return true;
                }
            }
        }
        return false;
    }
}
