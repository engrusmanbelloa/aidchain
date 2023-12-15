// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        uint256 chainId;
    }

    constructor() {
        if (block.chainid == 1) {
            activeNetworkConfig = getEthMainnetConfig();
        } else if (block.chainid == 137) {
            activeNetworkConfig = getPolygonConfig();
        } else if (block.chainid == 42161) {
            activeNetworkConfig = getArbitrumConfig();
        } else if (block.chainid == 11155111) {
            activeNetworkConfig = getAnvilLocalChainConfig();
        } else {
            revert("Unsupported network");
        }
    }

    function getEthMainnetConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({chainId: 1});
    }

    function getPolygonConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({chainId: 137});
    }

    function getArbitrumConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({chainId: 42161});
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({chainId: 11155111});
    }

    function getAnvilLocalChainConfig()
        public
        pure
        returns (NetworkConfig memory)
    {
        return NetworkConfig({chainId: 11155111});
    }
}
