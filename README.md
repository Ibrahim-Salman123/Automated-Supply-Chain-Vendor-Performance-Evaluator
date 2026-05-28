# VendorEvaluator Smart Contract

A decentralized supply chain management and vendor performance evaluation system built on Ethereum using Solidity. This contract allows a quality auditor to track product shipment timelines and check for quality defects.

---

## 📌 Overview

The **VendorEvaluator** smart contract helps organizations monitor vendor reliability transparently. By logging expected delivery timelines and evaluating the actual arrival time along with product quality, the system automatically calculates a vendor's performance score (punctuality vs. defect rate) directly on-chain.

---

## 🛠 Features

* **Role-Based Security:** Strict access control ensures only the designated `qualityAuditor` can log and finalize shipments.
* **Automated Timeline Tracking:** Dynamically calculates deadlines using blockchain timestamps (`block.timestamp`).
* **Performance Scoring:** Provides a public view function to instantly check any vendor's total, punctual, and defective delivery count.
* **Data Integrity:** Prevents reprocessing or tampering with shipments that have already been finalized.

---

## 📄 Smart Contract Architecture

### Data Structures

#### `Delivery` (Struct)
Tracks the lifecycle of a specific shipment:
* `expectedTime`: The deadline timestamp calculated when the shipment is logged.
* `actualTime`: The exact timestamp when the auditor updates the status.
* `isDefective`: Boolean flag indicating if the received products were faulty.
* `completed`: Status flag to lock the shipment data after processing.

### State Variables
* `vendorDeliveries`: A public mapping linking a vendor's wallet address to an array of their historic `Delivery` records.
* `qualityAuditor`: The Ethereum address of the administrator (contract deployer) responsible for quality control.

---

## ⚙️ Core Functions

#### 1. `logIncomingShipment(address _vendor, uint256 _expectedDaysToDelivery)`
* **Permission:** Only `qualityAuditor`
* **Description:** Registers a new pending shipment for a vendor and sets the expected delivery deadline based on the number of days provided.

#### 2. `finalizeShipmentStatus(address _vendor, uint256 _index, bool _isDefective)`
* **Permission:** Only `qualityAuditor`
* **Description:** Closes a pending shipment record by stamping the actual delivery time and logging whether the goods were defective or acceptable.

#### 3. `getVendorScore(address _vendor)`
* **Permission:** Public View (Free to call)
* **Description:** Loops through a vendor's delivery history and returns three metrics: total punctual deliveries, total defective deliveries, and overall shipment count.

---

## 🔔 Events

* `DeliveryLogged(address indexed vendor, uint256 expectedTime)`: Emitted when a new shipment tracking process starts.
* `DeliveryUpdated(address indexed vendor, bool isDefective, uint256 actualTime)`: Emitted when a shipment is completed and evaluated.

---

## 🚀 Tech Stack & Setup

* **Language:** Solidity `^0.8.20`
* **Tools:** Remix IDE / Hardhat / Foundry

### Quick Deploy

1. Open **Remix IDE**.
2. Create `VendorEvaluator.sol` and paste the code.
3. Compile using version `0.8.20`.
4. Deploy the contract. The deploying address automatically becomes the `qualityAuditor`.

---

## ⚖️ License

This project is licensed under the **MIT License**.
