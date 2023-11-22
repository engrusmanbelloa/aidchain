// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./UserOnboarding.sol";

contract UserOnboardingWithOwnership is UserOnboarding {
    address public owner;
    uint256 public programProposalsLength;

    constructor() UserOnboarding() {}

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }
}

contract Governance is UserOnboardingWithOwnership {
    enum ProposalStatus {
        Pending,
        Approved,
        Rejected
    }

    struct Proposal {
        address proposer;
        string description;
        ProposalStatus status;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 startTime;
        uint256 endTime;
    }

    mapping(uint256 => mapping(address => Vote)) public proposalVotes;
    mapping(uint256 => uint256) public proposalVoteCounts;

    struct Vote {
        bool inSupport;
        bool hasVoted;
    }

    Proposal[] public programProposals;

    modifier onlyProgramOwner(uint256 _proposalIndex) {
        require(
            programProposals[_proposalIndex].proposer == msg.sender,
            "Not program proposer"
        );
        _;
    }

    function proposeProgram(
        string memory _description,
        uint256 _startTime,
        uint256 _endTime
    ) external onlyRegistered {
        require(
            block.timestamp < _startTime,
            "Proposal start time must be in the future"
        );

        programProposals.push(
            Proposal({
                proposer: msg.sender,
                description: _description,
                status: ProposalStatus.Pending,
                votesFor: 0,
                votesAgainst: 0,
                startTime: _startTime,
                endTime: _endTime
            })
        );
        programProposalsLength++;
    }

    function votingStarted(uint256 _proposalIndex) public view returns (bool) {
        require(
            _proposalIndex < programProposals.length,
            "Invalid proposal index"
        );
        return block.timestamp >= programProposals[_proposalIndex].startTime;
    }

    function voteOnProposal(
        uint256 _proposalIndex,
        bool _supports
    ) external onlyRegistered {
        require(
            _proposalIndex < programProposals.length,
            "Invalid proposal index"
        );

        Proposal storage proposal = programProposals[_proposalIndex];
        require(
            block.timestamp >= proposal.startTime,
            "Voting has not started yet"
        );
        require(block.timestamp <= proposal.endTime, "Voting has ended");
        require(
            !proposalVotes[_proposalIndex][msg.sender].hasVoted,
            "Already voted"
        );

        if (_supports) {
            proposal.votesFor++;
        } else {
            proposal.votesAgainst++;
        }

        proposalVotes[_proposalIndex][msg.sender] = Vote({
            inSupport: _supports,
            hasVoted: true
        });
    }

    function finalizeProposal(uint256 _proposalIndex) external onlyOwner {
        require(
            _proposalIndex < programProposals.length,
            "Invalid proposal index"
        );

        Proposal storage proposal = programProposals[_proposalIndex];
        require(block.timestamp > proposal.endTime, "Voting has not ended yet");

        if (proposal.votesFor > proposal.votesAgainst) {
            proposal.status = ProposalStatus.Approved;
        } else {
            proposal.status = ProposalStatus.Rejected;
        }
        programProposalsLength--;
    }

    function getProposal(
        uint256 _proposalIndex
    )
        external
        view
        returns (
            address proposer,
            string memory description,
            ProposalStatus status,
            uint256 votesFor,
            uint256 votesAgainst,
            uint256 startTime,
            uint256 endTime
        )
    {
        require(
            _proposalIndex < programProposals.length,
            "Invalid proposal index"
        );

        Proposal memory proposal = programProposals[_proposalIndex];
        return (
            proposal.proposer,
            proposal.description,
            proposal.status,
            proposal.votesFor,
            proposal.votesAgainst,
            proposal.startTime,
            proposal.endTime
        );
    }

    function getProgramProposalCount() external view returns (uint256) {
        return programProposals.length;
    }
}
