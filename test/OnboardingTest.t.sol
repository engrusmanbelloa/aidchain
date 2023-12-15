// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {UserOnboarding} from "../src/UserOnboarding.sol";
import {DeployOnboarding} from "../script/DeployOnboarding.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract OnboardingTests is Test {
    // UserOnboarding userOnboarding;
    UserOnboarding userOnboarding;

    function setUp() public {
        // Us trying to tell OnboardingTests to call UserOnboarding for us.
        // userOnboarding = new UserOnboarding();
        DeployOnboarding deployOnboarding = new DeployOnboarding();
        userOnboarding = deployOnboarding.run();
    }

    function test_RegisterUser() public {
        address userAddress = address(this);
        address deployerAddress = msg.sender;
        console.log("The contract of the UserOnboarding: ", deployerAddress);
        console.log("The contract of the OnboardingTests: ", userAddress);

        userOnboarding.registerUser(userAddress);

        assertTrue(
            userOnboarding.registeredUsers(userAddress),
            "User should be registered."
        );
        assertTrue(
            userOnboarding.isAddressRegistered(userAddress),
            "Address should be registered."
        );

        address userFromContract = userOnboarding.userToAddress(userAddress);
        assertEq(
            userFromContract,
            userAddress,
            "User's address should match the registered address."
        );
    }

    function test_GetUserAddress() public {
        address userAddress = address(this);

        userOnboarding.registerUser(userAddress);

        address userFromContract = userOnboarding.getUserAddress(msg.sender);

        assertNotEq(
            userFromContract,
            userAddress,
            "User's address should no match the registered address."
        );
    }
}
