// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import "forge-std/Script.sol";
import "../../src/CrossChainReceiver.sol";

contract DeployCrossChainReceiver is Script {
    function run() external {
        // Retrieve deployment parameters from environment variables
        address wormholeRelayer = vm.envAddress("CELO_WORMHOLE_RELAYER");
        address tokenBridge = vm.envAddress("CELO_TOKENBRIDGE");
        address wormhole = vm.envAddress("CELO_WORMHOLE");
        uint16 fujiChainId = uint16(vm.envUint("FUJI_CHAIN_ID"));

        vm.startBroadcast();
        // Deploy smart contract
        CrossChainReceiver crossChainReceiver = new CrossChainReceiver(wormholeRelayer, tokenBridge, wormhole);

        // Set registered sender
        crossChainReceiver.setRegisteredSender(
            fujiChainId, bytes32(uint256(uint160(address(vm.envAddress("FUJI_SENDER_ADDRESS")))))
        );
        vm.stopBroadcast();

        console.log("CrossChainReceiver deployed on Celo at:", address(crossChainReceiver));
    }
}

// forge script script/CeloReceiver/DeployCrossChainReceiver.s.sol:DeployCrossChainReceiver --account defaultKey --sender $WALLET_ADDRESS --rpc-url $CELO_RPC_URL --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY -vvv
