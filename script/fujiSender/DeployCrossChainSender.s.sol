// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import "forge-std/Script.sol";
import "../../src/CrossChainSender.sol";

contract DeployCrossChainSender is Script {
    function run() external {
        // Retrieve deployment parameters from environment variables
        address wormholeRelayer = vm.envAddress("FUJI_WORMHOLE_RELAYER");
        address tokenBridge = vm.envAddress("FUJI_TOKENBRIDGE");
        address wormhole = vm.envAddress("FUJI_WORMHOLE");

        vm.startBroadcast();
        CrossChainSender crossChainSender = new CrossChainSender(wormholeRelayer, tokenBridge, wormhole);
        crossChainSender.setGasLimit(uint256(250_000));
        vm.stopBroadcast();

        console.log("CrossChainSender deployed on Fuji at:", address(crossChainSender));
    }
}

// forge script script/fujiSender/DeployCrossChainSender.s.sol:DeployCrossChainSender --account defaultKey --sender $WALLET_ADDRESS --rpc-url $FUJI_RPC_URL --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY -vvv
