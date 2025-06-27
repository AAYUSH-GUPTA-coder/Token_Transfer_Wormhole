// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../../src/CrossChainSender.sol";

interface ITokenBridge {
    function wrappedAsset(uint16 tokenChainId, bytes32 tokenAddress) external view returns (address);
}

contract CheckAttestationCelo is Script {
    function run() external {
        uint16 celoChainId = uint16(vm.envUint("CELO_CHAIN_ID"));
        address tokenBridge = vm.envAddress("CELO_TOKENBRIDGE");
        address celoTokenAddress = vm.envAddress("CELO_USDC_ADDRESS");
        ITokenBridge tokenBridgeContract = ITokenBridge(tokenBridge);

        console.log("celoTokenAddress bytes ");
        console.logBytes32(bytes32(uint256(uint160(address(celoTokenAddress)))));

        vm.startBroadcast();
        address tokenAddress =
            tokenBridgeContract.wrappedAsset(celoChainId, bytes32(uint256(uint160(address(celoTokenAddress)))));
        vm.stopBroadcast();

        console.log("celoTokenAddress bytes ");
        console.logBytes32(bytes32(uint256(uint160(address(celoTokenAddress)))));
        console.log("wrappedTokenAddress ", tokenAddress);
    }
}

// forge script script/CeloReceiver/CheckAttestationCelo.s.sol:CheckAttestationCelo --account defaultKey --sender $WALLET_ADDRESS --rpc-url $FUJI_RPC_URL --broadcast -vvv

// forge script script/CeloReceiver/CheckAttestationCelo.s.sol:CheckAttestationCelo --account defaultKey --sender $WALLET_ADDRESS --rpc-url $CELO_RPC_URL --broadcast -vvv
