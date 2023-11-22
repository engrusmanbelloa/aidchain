// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {UserOnboarding} from "../src/UserOnboarding.sol";

contract OnboardingTests is Test {
    UserOnboarding userOnboarding;

    function setUp() public {
        // Us trying to tell OnboardingTests to call UserOnboarding for us.
        userOnboarding = new UserOnboarding();
    }

    function test_RegisterUser() public {
        address userAddress = address(this);
        console.log("The contract of the UserOnboarding: ", msg.sender);
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

    // function test_RegisterUser_AddressAlreadyRegistered() public {
    //     address userAddress = address(this);
    //     address userAddress2 = address(this);

    //     // Register the user address
    //     userOnboarding.registerUser(userAddress);

    //     // // Attempt to register the same address again
    //     // userOnboarding.registerUser(userAddress2);

    //     assertTrue(
    //         userOnboarding.isAddressRegistered(userAddress),
    //         "Address should be registered."
    //     );
    //     assertFalse(
    //         userOnboarding.isAddressRegistered(userAddress2),
    //         "Address should not be registered."
    //     );
    // }

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
