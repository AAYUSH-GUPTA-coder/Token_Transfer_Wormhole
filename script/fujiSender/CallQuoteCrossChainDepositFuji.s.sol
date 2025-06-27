// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import "forge-std/Script.sol";
import "../../src/CrossChainSender.sol";

contract CallQuoteCrossChainDepositFuji is Script {
    function run() external {
        uint16 celoChainId = uint16(vm.envUint("CELO_CHAIN_ID"));
        address fujiSenderAddress = vm.envAddress("FUJI_SENDER_ADDRESS");
        CrossChainSender crossChainSender = CrossChainSender(fujiSenderAddress);

        vm.startBroadcast();
        uint256 cost = crossChainSender.quoteCrossChainDeposit(celoChainId);
        vm.stopBroadcast();

        console.log("The cost of the cross-chain transfer is", cost);
    }
}

// forge script script/fujiSender/CallQuoteCrossChainDepositFuji.s.sol:CallQuoteCrossChainDepositFuji --account defaultKey --sender $WALLET_ADDRESS --rpc-url $FUJI_RPC_URL --broadcast -vvv
