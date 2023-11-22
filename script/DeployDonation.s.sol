// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {UserOnboarding} from "../src/UserOnboarding.sol";

contract DeployOnboarding is Script {
    function run() external {
        vm.startBroadcast();
        new UserOnboarding();
        vm.stopBroadcast();
    }
}
