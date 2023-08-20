// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "./Onboarding.sol";

contract UserOnboardingWithOwnership is UserOnboarding {
    address public owner;

    constructor() UserOnboarding() {}

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }
}

contract DisasterReliefFund is UserOnboardingWithOwnership {
    IERC20 public cUSD;

    event AidDistributed(address beneficiary, string name, uint256 amount);

    struct EmergencyReliefFund {
        address owner;
        string name;
        uint256 targetAmount;
        uint256 currentAmount;
        uint256 startTime;
        uint256 endTime;
        bool funded;
    }

    EmergencyReliefFund[] public emergencyReliefFunds;
    mapping(uint256 => address[]) public programApplicants;

    modifier onlyEmergencyFundOwner(uint256 _fundIndex) {
        require(
            emergencyReliefFunds[_fundIndex].owner == msg.sender,
            "Not fund owner"
        );
        _;
    }

    constructor(address _celoTokenAddress) {
        cUSD = IERC20(_celoTokenAddress);
        owner = msg.sender;
    }

    function proposeEmergencyReliefFund(
        string memory _name,
        uint256 _targetAmount,
        uint256 _startTime,
        uint256 _endTime
    ) external onlyOwner {
        require(_targetAmount > 0, "Target amount must be greater than 0");
        require(
            _startTime > block.timestamp,
            "Start time must be in the future"
        );
        require(
            _endTime > block.timestamp,
            "Endtime time must be in the future"
        );

        emergencyReliefFunds.push(
            EmergencyReliefFund({
                owner: msg.sender,
                name: _name,
                targetAmount: _targetAmount,
                currentAmount: 0,
                startTime: _startTime,
                endTime: _endTime,
                funded: false
            })
        );
    }

    function donateToEmergencyFund(
        uint256 _fundIndex,
        uint256 _amount
    ) external onlyRegistered {
        require(_fundIndex < emergencyReliefFunds.length, "Invalid fund index");
        require(
            block.timestamp >= emergencyReliefFunds[_fundIndex].startTime,
            "Fundraising not started"
        );
        require(
            block.timestamp <= emergencyReliefFunds[_fundIndex].endTime,
            "Fundraising ended"
        );
        require(_amount > 0, "Donation amount must be greater than 0");

        EmergencyReliefFund storage fund = emergencyReliefFunds[_fundIndex];

        // Transfer the donation amount from the user to the contract
        cUSD.transferFrom(msg.sender, address(this), _amount);

        // Update the current amount of the fund
        fund.currentAmount += _amount;

        // If the current amount reaches the target amount, mark the fund as funded
        if (fund.currentAmount >= fund.targetAmount) {
            fund.funded = true;
        }
    }

    function applyForEmergencyRelief(
        uint256 _fundIndex
    ) external onlyRegistered {
        require(_fundIndex < emergencyReliefFunds.length, "Invalid fund index");
        require(
            block.timestamp >= emergencyReliefFunds[_fundIndex].startTime,
            "Fundraising not started"
        );
        require(
            block.timestamp <= emergencyReliefFunds[_fundIndex].endTime,
            "Fundraising ended"
        );

        // EmergencyReliefFund storage fund = emergencyReliefFunds[_fundIndex];

        // Add the applicant to the list of beneficiaries
        programApplicants[_fundIndex].push(msg.sender);
    }

    function distributeEmergencyFund(
        uint256 _fundIndex
    ) external onlyEmergencyFundOwner(_fundIndex) {
        require(_fundIndex < emergencyReliefFunds.length, "Invalid fund index");
        require(
            emergencyReliefFunds[_fundIndex].funded,
            "Fund not fully funded"
        );
        require(
            block.timestamp > emergencyReliefFunds[_fundIndex].endTime,
            "Fundraising not ended"
        );

        EmergencyReliefFund storage fund = emergencyReliefFunds[_fundIndex];

        // Distribute the fund to the beneficiaries based on equal division
        address[] memory beneficiaries = programApplicants[_fundIndex];
        uint256 totalBeneficiaries = beneficiaries.length;
        uint256 distributedAmount = fund.currentAmount / totalBeneficiaries;

        for (uint256 i = 0; i < totalBeneficiaries; i++) {
            address beneficiary = beneficiaries[i];
            // Transfer the distributed amount to the beneficiary
            cUSD.transfer(beneficiary, distributedAmount);
            emit AidDistributed(beneficiary, fund.name, distributedAmount);
        }

        // Reset the fund for future use
        fund.currentAmount = 0;
        fund.funded = false;
    }

    // Function to check if a user is a beneficiary of a specific emergency fund
    function isBeneficiaryOfFund(
        address _user,
        uint256 _fundIndex
    ) external view returns (bool) {
        require(_fundIndex < emergencyReliefFunds.length, "Invalid fund index");

        EmergencyReliefFund storage fund = emergencyReliefFunds[_fundIndex];
        return userToAddress[_user] == fund.owner;
    }

    // Function to check if a user has ever benefited from any emergency fund
    function hasBenefitedFromAnyFund(
        address _user
    ) external view returns (bool) {
        for (uint256 i = 0; i < emergencyReliefFunds.length; i++) {
            if (userToAddress[_user] == emergencyReliefFunds[i].owner) {
                return true;
            }
        }
        return false;
    }
}
