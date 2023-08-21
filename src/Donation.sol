// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Governance.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract Donation is Governance {
    IERC20 public cUSD;
    // address public owner;
    mapping(address => bool) public programRegistered;
    // Mapping to associate each DonationOption with its userFunds array
    mapping(uint256 => UserFunds[]) private donationOptionToFunds;
    // Mapping to track program applicants
    mapping(uint256 => address[]) public programApplicants;

    // events
    event ProgramRegistered(string name, address recipient);

    // structs
    struct UserFunds {
        address user;
        uint256 amount;
    }

    struct DonationOption {
        string name;
        address recipient;
        uint256 totalFunded; // Total amount funded for this option
        uint256 startTime;
        uint256 endTime;
    }

    DonationOption[] public donationOptions;

    modifier onlyRegisteredProgram() {
        require(programRegistered[msg.sender], "Program not registered");
        _;
    }

    constructor(address _celoTokenAddress) {
        cUSD = IERC20(_celoTokenAddress);
        owner = msg.sender;
    }

    // Function to allow users to apply for program participation
    function applyForProgram(uint256 _proposalIndex) external onlyRegistered {
        require(
            _proposalIndex < programProposals.length,
            "Invalid proposal index"
        );

        Proposal storage proposal = programProposals[_proposalIndex];
        require(
            proposal.status == ProposalStatus.Approved,
            "Proposal not approved"
        );
        require(block.timestamp >= proposal.startTime, "Program not started");
        require(block.timestamp <= proposal.endTime, "Program ended");

        address applicant = userToAddress[msg.sender];

        // Add applicant to the list
        programApplicants[_proposalIndex].push(applicant);
    }

    // Function to retrieve applicants for a specific program
    function getApplicantsForProgram(
        uint256 _proposalIndex
    ) internal view returns (address[] memory) {
        require(
            _proposalIndex < programProposals.length,
            "Invalid proposal index"
        );
        return programApplicants[_proposalIndex];
    }

    // Function to donate only winning proposals
    function donateToWinningProposal(
        uint256 _proposalIndex,
        uint256 _amount
    ) public payable onlyRegistered {
        require(
            _proposalIndex < programProposals.length,
            "Invalid proposal index"
        );

        Proposal storage proposal = programProposals[_proposalIndex];
        require(
            proposal.status == ProposalStatus.Approved,
            "Proposal not approved"
        );
        require(block.timestamp >= proposal.startTime, "Program not started");
        require(block.timestamp <= proposal.endTime, "Program ended");
        require(_amount >= 10 * 1e18, "Minimum donation amount not met");

        address donor = userToAddress[msg.sender];

        // Transfer the donation amount from the user to the proposer
        cUSD.transferFrom(msg.sender, proposal.proposer, _amount);

        // Update donation records
        uint256 optionIndex = donationOptions.length - 1; // Index of the latest program
        DonationOption storage chosenOption = donationOptions[optionIndex];
        chosenOption.totalFunded += _amount;

        // Add or update user's funds for this donation option
        UserFunds[] storage userFunds = donationOptionToFunds[optionIndex];
        updateUserFunds(userFunds, donor, _amount);

        // Emit an event to log the donation
        emit DonationMade(donor, proposal.description, _amount);
    }

    function updateUserFunds(
        UserFunds[] storage funds,
        address user,
        uint256 amount
    ) private {
        bool userFound = false;

        for (uint256 i = 0; i < funds.length; i++) {
            if (funds[i].user == user) {
                funds[i].amount += amount;
                userFound = true;
                break;
            }
        }

        if (!userFound) {
            funds.push(UserFunds(user, amount));
        }
    }

    function getUserFundsIndex(
        UserFunds[] storage userFunds,
        address user
    ) internal view returns (int256) {
        for (uint256 i = 0; i < userFunds.length; i++) {
            if (userFunds[i].user == user) {
                return int256(i);
            }
        }
        return -1;
    }

    function getDonationOption(
        uint256 _optionIndex
    )
        public
        view
        returns (string memory name, address recipient, uint256 totalFunded)
    {
        require(_optionIndex < donationOptions.length, "Invalid option index");

        DonationOption memory option = donationOptions[_optionIndex];
        return (option.name, option.recipient, option.totalFunded);
    }

    function getUserDonation(
        address _user,
        uint256 _optionIndex
    ) public view returns (uint256) {
        require(_optionIndex < donationOptions.length, "Invalid option index");

        UserFunds[] storage userFunds = donationOptionToFunds[_optionIndex];

        for (uint256 i = 0; i < userFunds.length; i++) {
            if (userFunds[i].user == _user) {
                return userFunds[i].amount;
            }
        }

        return 0; // User has not made a donation for this option
    }

    function getAllUsersForOption(
        uint256 _optionIndex
    ) public view returns (address[] memory) {
        require(_optionIndex < donationOptions.length, "Invalid option index");

        UserFunds[] storage userFunds = donationOptionToFunds[_optionIndex];

        address[] memory users = new address[](userFunds.length);

        for (uint256 i = 0; i < userFunds.length; i++) {
            users[i] = userFunds[i].user;
        }

        return users;
    }

    function getProgramStatus(
        uint256 _optionIndex
    ) public view returns (string memory status) {
        require(_optionIndex < donationOptions.length, "Invalid option index");

        DonationOption storage option = donationOptions[_optionIndex];
        uint256 currentTime = block.timestamp;

        if (currentTime < option.startTime) {
            return "Upcoming";
        } else if (
            currentTime >= option.startTime && currentTime <= option.endTime
        ) {
            return "Active";
        } else {
            return "Passed";
        }
    }

    event DonationMade(
        address indexed donor,
        string optionName,
        uint256 amount
    );
}
