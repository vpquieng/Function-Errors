// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract SimpleDeliveryService {
    address public owner;

    struct Delivery {
        uint256 id;
        address receiver;
        string name;
        string deliveryAddress;
        uint256 deliveryFee;
        bool isCancelled;
    }

    mapping(uint256 => Delivery) public deliveries;
    uint256 public deliveryCount;

    event DeliveryRequested(uint256 deliveryId, address receiver, uint256 deliveryFee, string itemName, string deliveryAddress);
    event DeliveryCancelled(uint256 deliveryId, address receiver);
    event DeliveryRefunded(uint256 deliveryId, address receiver, uint256 amountRefunded);

    constructor() {
        owner = msg.sender; // Set the deployer as the owner
    }

    // Function to request a new delivery
    function requestDelivery(string memory itemName, string memory deliveryAddress) public payable {
        require(msg.value > 0.01 ether, "The minimum fee for delivery fee is 0.01 ether");
        deliveryCount++;
        deliveries[deliveryCount] = Delivery({
            id: deliveryCount,
            name: itemName,
            receiver: msg.sender,
            deliveryAddress: deliveryAddress,
            deliveryFee: msg.value,
            isCancelled: false
        });
        emit DeliveryRequested(deliveryCount, msg.sender, msg.value, itemName, deliveryAddress);
    }

    // Function to cancel a delivery process
    function cancelDelivery(uint256 deliveryId) public {
        require(deliveries[deliveryId].receiver == msg.sender, "You are not the receiver of this delivery");
        require(!deliveries[deliveryId].isCancelled, "This delivery has already been cancelled");

        uint256 refundAmount = deliveries[deliveryId].deliveryFee;
        deliveries[deliveryId].isCancelled = true;

        // Checks if the refund is successful
        (bool success,) = payable(msg.sender).call{value: refundAmount}("The refund is successfull!");
        require(success, "The refund is unsuccessful");

        emit DeliveryCancelled(deliveryId, msg.sender);
        emit DeliveryRefunded(deliveryId, msg.sender, refundAmount);
    }

    // Function to view delivery details
    function deliveryDetails(uint256 deliveryId) public view returns(
        uint256 id,
        string memory name,
        string memory deliveryAddress,
        address receiver,
        uint256 deliveryFee,
        bool isCancelled
    ) {
        // get details from mapping and returns value from struct
        Delivery storage delivery = deliveries[deliveryId];
        return (
            delivery.id,
            delivery.name,
            delivery.deliveryAddress,
            delivery.receiver,
            delivery.deliveryFee,
            delivery.isCancelled
        );
    }
    // Fallback function to accept Ether (for refunds)
    receive() external payable {}
}
