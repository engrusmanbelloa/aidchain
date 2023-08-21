// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UserOnboarding {
    mapping(address => bool) public registeredUsers;
    mapping(address => bool) public isAddressRegistered;
    mapping(address => address) public userToAddress;

    modifier onlyRegistered() {
        require(registeredUsers[msg.sender], "User not registered");
        _;
    }

    modifier addressNotRegistered(address _userAddress) {
        require(
            !isAddressRegistered[_userAddress],
            "Address is already registered"
        );
        _;
    }

    function registerUser(
        address _userAddress
    ) external addressNotRegistered(_userAddress) {
        registeredUsers[msg.sender] = true;
        isAddressRegistered[_userAddress] = true;
        userToAddress[msg.sender] = _userAddress;
    }

    function getUserAddress(address _user) external view returns (address) {
        return userToAddress[_user];
    }
}
