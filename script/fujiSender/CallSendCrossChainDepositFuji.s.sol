// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../../src/CrossChainSender.sol";

contract CallSendCrossChainDepositFuji is Script {
    function run() external {
        uint16 celoChainId = uint16(vm.envUint("CELO_CHAIN_ID"));
        address celoCrossChainReceiver = vm.envAddress("CELO_RECEIVER_ADDRESS");
        address recipient = vm.envAddress("WALLET_ADDRESS");
        uint256 amount = 1_000_000; // 1 USDC
        address fujiUsdcToken = vm.envAddress("FUJI_USDC_ADDRESS");

        CrossChainSender crossChainSender = CrossChainSender(vm.envAddress("FUJI_SENDER_ADDRESS"));

        vm.startBroadcast();
        uint256 cost = crossChainSender.quoteCrossChainDeposit(celoChainId);

        crossChainSender.sendCrossChainDeposit{value: cost}(
            celoChainId, celoCrossChainReceiver, recipient, amount, fujiUsdcToken
        );
        vm.stopBroadcast();

        console.log("The cost of the cross-chain deposit is", cost);
        console.log("Called the sendCrossChainDeposit function on Fuji on contract address", address(crossChainSender));
    }
}

// forge script script/fujiSender/CallSendCrossChainDepositFuji.s.sol:CallSendCrossChainDepositFuji --account defaultKey --sender $WALLET_ADDRESS --rpc-url $FUJI_RPC_URL --broadcast -vvv
