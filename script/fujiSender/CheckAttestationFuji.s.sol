// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import "forge-std/Script.sol";
import "../../src/CrossChainSender.sol";

interface ITokenBridge {
    function wrappedAsset(uint16 tokenChainId, bytes32 tokenAddress) external view returns (address);
}

contract CheckAttestationFuji is Script {
    function run() external {
        uint16 fujiChainId = uint16(vm.envUint("FUJI_CHAIN_ID"));
        address tokenBridge = vm.envAddress("FUJI_TOKENBRIDGE");
        address fujiTokenAddress = vm.envAddress("FUJI_USDC_ADDRESS");
        ITokenBridge tokenBridgeContract = ITokenBridge(tokenBridge);

        vm.startBroadcast();
        address tokenAddress =
            tokenBridgeContract.wrappedAsset(fujiChainId, bytes32(uint256(uint160(address(fujiTokenAddress)))));
        vm.stopBroadcast();

        console.log("Check token address ", tokenAddress);
    }
}

// forge script script/fujiSender/CheckAttestationFuji.s.sol:CheckAttestationFuji --account defaultKey --sender $WALLET_ADDRESS --rpc-url $FUJI_RPC_URL --broadcast -vvv

// forge script script/fujiSender/CheckAttestationCelo.s.sol:CheckAttestationCelo --account defaultKey --sender $WALLET_ADDRESS --rpc-url $CELO_RPC_URL --broadcast -vvv
