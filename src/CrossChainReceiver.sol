// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import "lib/wormhole-solidity-sdk/src/WormholeRelayerSDK.sol";
import "lib/wormhole-solidity-sdk/src/interfaces/IERC20.sol";

contract CrossChainReceiver is TokenReceiver {
    // The wormhole relayer and registeredSenders are inherited from the Base.sol contract.

    constructor(address _wormholeRelayer, address _tokenBridge, address _wormhole)
        TokenBase(_wormholeRelayer, _tokenBridge, _wormhole)
    {}

    /**
     * @notice Function to receive the cross-chain payload and tokens with emitter validation
     * @dev This function is called by the Wormhole Relayer contract on the target chain
     * @param payload The payload to be received
     * @param receivedTokens The tokens received
     * @param sourceAddress The source address of the message
     * @param sourceChain The source chain of the message
     */
    function receivePayloadAndTokens(
        bytes memory payload,
        TokenReceived[] memory receivedTokens,
        bytes32 sourceAddress,
        uint16 sourceChain,
        bytes32 // deliveryHash (not used in this implementation)
    ) internal override onlyWormholeRelayer isRegisteredSender(sourceChain, sourceAddress) {
        // Decode the recipient address from the payload
        address recipient = abi.decode(payload, (address));

        // Transfer the received tokens to the intended recipient
        IERC20(receivedTokens[0].tokenAddress).transfer(recipient, receivedTokens[0].amount);
    }
}
