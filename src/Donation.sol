// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Onboarding.sol";

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Donation is UserOnboarding {
    IERC20 public cUSD;
    address public owner;
    mapping(address => bool) public programRegistered;
    // Mapping to associate each DonationOption with its userFunds array
    mapping(uint256 => UserFunds[]) private donationOptionToFunds;
    // Mapping to track program applicants
    mapping(uint256 => address[]) private programApplicants;

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

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    modifier onlyRegisteredProgram() {
        require(programRegistered[msg.sender], "Program not registered");
        _;
    }

    constructor(address _celoTokenAddress) {
        cUSD = IERC20(_celoTokenAddress);
        owner = msg.sender;
    }

    // Function to register a donation program
    function registerDonationProgram(
        string memory _name,
        address _recipient,
        uint256 _startTime,
        uint256 _endTime
    ) external onlyOwner {
        donationOptions.push(
            DonationOption({
                name: _name,
                recipient: _recipient,
                totalFunded: 0,
                startTime: _startTime,
                endTime: _endTime
            })
        );

        programRegistered[_recipient] = true;

        emit ProgramRegistered(_name, _recipient);
    }

    // Function to allow users to apply for program participation
    function applyForProgram(uint256 _optionIndex) external onlyRegistered {
        require(_optionIndex < donationOptions.length, "Invalid option index");

        DonationOption storage chosenOption = donationOptions[_optionIndex];
        address applicant = userToAddress[msg.sender];

        // Check if the program is still active
        require(
            block.timestamp >= chosenOption.startTime,
            "Program not started"
        );
        require(block.timestamp <= chosenOption.endTime, "Program ended");

        // Add applicant to the list
        programApplicants[_optionIndex].push(applicant);
    }

    // Function to retrieve applicants for a specific program
    function getApplicantsForProgram(
        uint256 _optionIndex
    ) external view returns (address[] memory) {
        require(_optionIndex < donationOptions.length, "Invalid option index");
        return programApplicants[_optionIndex];
    }

    // Function to allow users to donatne in a program
    function donate(
        uint256 _optionIndex,
        uint256 _amount
    ) external onlyRegistered {
        require(_optionIndex < donationOptions.length, "Invalid option index");
        require(_amount >= 50 * 1e18, "Minimum donation amount not met");

        DonationOption storage chosenOption = donationOptions[_optionIndex];
        address donor = userToAddress[msg.sender];

        // Check if the program is still active
        require(
            block.timestamp >= chosenOption.startTime,
            "Program not started"
        );
        require(block.timestamp <= chosenOption.endTime, "Program ended");

        // Transfer the donation amount from the user to the recipient
        cUSD.transferFrom(msg.sender, chosenOption.recipient, _amount);

        // Update donation records
        chosenOption.totalFunded += _amount;

        // Add or update user's funds for this donation option
        UserFunds[] storage userFunds = donationOptionToFunds[_optionIndex];
        updateUserFunds(userFunds, donor, _amount);

        // Emit an event to log the donation
        emit DonationMade(donor, chosenOption.name, _amount);
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
        external
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
    ) external view returns (uint256) {
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
    ) external view returns (address[] memory) {
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
    ) external view returns (string memory status) {
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
