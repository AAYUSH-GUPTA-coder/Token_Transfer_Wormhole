// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import "lib/wormhole-solidity-sdk/src/WormholeRelayerSDK.sol";
import "lib/wormhole-solidity-sdk/src/interfaces/IERC20.sol";

contract CrossChainSender is TokenSender {
    /*//////////////////////////////////////////////////////////////
                                 ERROR
    //////////////////////////////////////////////////////////////*/
    error NotEnoughBridgingFees();

    /*//////////////////////////////////////////////////////////////
                                 STATE
    //////////////////////////////////////////////////////////////*/
    uint256 private gasLimit;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event GasLimitSet(uint256 gasLimit);

    /*//////////////////////////////////////////////////////////////
                                 CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor(address _wormholeRelayer, address _tokenBridge, address _wormhole)
        TokenBase(_wormholeRelayer, _tokenBridge, _wormhole)
    {}

    /*//////////////////////////////////////////////////////////////
                                 FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                                PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    /**
     * @notice Sets the gas limit for cross-chain deposits
     * @param _gasLimit The gas limit for cross-chain deposits
     */
    function setGasLimit(uint256 _gasLimit) public {
        emit GasLimitSet(_gasLimit);
        gasLimit = _gasLimit;
    }

    /**
     * @notice Gets the estimated cost for cross-chain deposit
     * @param targetChain The target chain to send the token and payload to
     */
    function quoteCrossChainDeposit(uint16 targetChain) public view returns (uint256 cost) {
        // Get the cost of delivering the token and payload to the target chain
        uint256 deliveryCost;
        (deliveryCost,) = wormholeRelayer.quoteEVMDeliveryPrice(
            targetChain,
            0, // receiver value (set to 0 in this example)
            gasLimit
        );

        // Total cost: delivery cost + cost of publishing the Wormhole message
        cost = deliveryCost + wormhole.messageFee();
    }

    // Function to send tokens and payload across chains
    function sendCrossChainDeposit(
        uint16 targetChain, // Wormhole chain ID for the target chain
        address targetReceiver, // Address of the TokenReceiver contract on the target chain
        address recipient, // Recipient address on the target chain
        uint256 amount, // Amount of tokens to send
        address token // Address of the IERC20 token contract
    ) public payable {
        // Get the cost for cross-chain deposit
        uint256 cost = quoteCrossChainDeposit(targetChain);
        if (msg.value < cost) revert NotEnoughBridgingFees();

        // Transfer the specified amount of tokens from the user to this contract
        IERC20(token).transferFrom(msg.sender, address(this), amount);

        // Encode the recipient's address into a payload
        bytes memory payload = abi.encode(recipient);

        // Use the Wormhole SDK to send the token and payload cross-chain
        sendTokenWithPayloadToEvm(
            targetChain,
            targetReceiver, // Address on the target chain to send the token and payload
            payload,
            0, // Receiver value (set to 0 in this example)
            gasLimit,
            token, // Address of the IERC20 token contract
            amount
        );
    }

    /*//////////////////////////////////////////////////////////////
                                VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Returns the gas limit for cross-chain deposits
    function getGasLimit() public view returns (uint256) {
        return gasLimit;
    }
}
