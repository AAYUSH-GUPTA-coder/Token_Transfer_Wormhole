// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "lib/wormhole-solidity-sdk/src/interfaces/IERC20.sol";

contract CallFujiTokenApproval is Script {
    function run() external {
        address fujiUsdcToken = vm.envAddress("FUJI_USDC_ADDRESS");
        address fujiSenderAddress = vm.envAddress("FUJI_SENDER_ADDRESS");
        uint256 amount = 1000_000_000; // 1000 USDC

        vm.startBroadcast();
        IERC20(fujiUsdcToken).approve(fujiSenderAddress, amount);
        vm.stopBroadcast();
    }
}

// forge script script/fujiSender/CallFujiTokenApproval.s.sol:CallFujiTokenApproval --account defaultKey --sender $WALLET_ADDRESS --rpc-url $FUJI_RPC_URL --broadcast -vvv
