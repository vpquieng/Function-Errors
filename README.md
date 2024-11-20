# SimpleDeliveryService Smart Contract

## Overview

**SimpleDeliveryService** is a Solidity-based smart contract that enables users to manage delivery services on the Ethereum blockchain. Users can request deliveries by paying a fee, view delivery details, and cancel deliveries to receive refunds. The contract ensures secure handling of payments and maintains a record of all deliveries.

## Features

- **Delivery Requests**: Users can request deliveries by providing an item name, delivery address, and a payment fee.
- **Cancellation with Refund**: Users can cancel deliveries and receive a refund if certain conditions are met.
- **Delivery Details**: Public access to view detailed information about each delivery.
- **Owner Management**: The contract deployer is set as the owner, though the current version doesn’t include owner-specific actions.
- **Fallback Ether Handling**: Accepts Ether transfers for refunds.

## Contract Details

- **Solidity Version**: `0.8.26`
- **Constructor**: Sets the deployer as the owner.
- **Delivery Fee**: Minimum fee for delivery is `0.01 ether`.

## Functions

### 1. requestDelivery(string memory itemName, string memory deliveryAddress)
Allows users to request a delivery by providing item details and paying the required fee. Creates a new delivery entry in the system.
```solidity
function requestDelivery(string memory itemName, string memory deliveryAddress) public payable;
```
### Parameters:
- itemName: Name of the item to be delivered.
- deliveryAddress: Address where the delivery is to be made.

### Events:
- Emits DeliveryRequested upon successful delivery creation.

### 2. cancelDelivery(uint256 deliveryId)
Allows users to cancel an existing delivery they requested. The function verifies the caller as the delivery receiver and ensures the delivery hasn’t already been canceled. Refunds the delivery fee upon success.
```solidity
function cancelDelivery(uint256 deliveryId) public;
```
### Parameters:
- deliveryId: Unique ID of the delivery to cancel.

### Events:
- Emits `DeliveryCancelled` and `DeliveryRefunded` upon successful cancellation and refund.

### 3. deliveryDetails(uint256 deliveryId)
Fetches and returns the details of a specific delivery.
```solidity
function deliveryDetails(uint256 deliveryId) public view returns (
    uint256 id,
    string memory name,
    string memory deliveryAddress,
    address receiver,
    uint256 deliveryFee,
    bool isCancelled
);
```
### Returns:
- Delivery details, including ID, item name, delivery address, receiver, fee, and cancellation status.

### 4. receive() external payable
- Fallback function to accept Ether payments. Ensures the contract can handle incoming Ether for refunds.

## How to Use
1. Deploy the Contract: Use an Ethereum development environment such as Remix, Hardhat, or Truffle to deploy the contract.

2. Request a Delivery: Call the requestDelivery function with an item name, delivery address, and a payment fee (minimum 0.01 ether).

3. View Delivery Details: Call the deliveryDetails function with the delivery ID to view the details of a delivery.

4. Cancel a Delivery: If needed, cancel your delivery by calling the cancelDelivery function with the delivery ID. Ensure you’re the receiver and the delivery hasn’t already been canceled.

### Example
Here's an example of how to interact with the contract:
- Request a Delivery
```solidity
requestDelivery("Handbag", "Manila");
```
- Cancel a Delivery
```solidity
cancelDelivery(1);
```
- View delivery details
```solidity
deliveryDetails(1);
```
## Contributors
- **Vincent Paul Quieng** - Developer 

## License 
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
