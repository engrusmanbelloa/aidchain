// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {UserOnboarding} from "../src/UserOnboarding.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployOnboarding is Script {
    function run() external returns (UserOnboarding) {
        HelperConfig helperConfig = new HelperConfig();
        uint256 chainId = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        UserOnboarding userOnboarding = new UserOnboarding();
        vm.stopBroadcast();

        return userOnboarding;
    }
}
