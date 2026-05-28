// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VendorEvaluator {
    struct Delivery {
        uint256 expectedTime;
        uint256 actualTime;
        bool isDefective;
        bool completed;
    }

    mapping(address => Delivery[]) public vendorDeliveries;
    address public qualityAuditor;

    event DeliveryLogged(address indexed vendor, uint256 expectedTime);
    event DeliveryUpdated(address indexed vendor, bool isDefective, uint256 actualTime);

    constructor() {
        qualityAuditor = msg.sender;
    }

    function logIncomingShipment(address _vendor, uint256 _expectedDaysToDelivery) external {
        require(msg.sender == qualityAuditor, "Only quality auditor can log");
        vendorDeliveries[_vendor].push(Delivery({
            expectedTime: block.timestamp + (_expectedDaysToDelivery * 1 days),
            actualTime: 0,
            isDefective: false,
            completed: false
        }));
        emit DeliveryLogged(_vendor, block.timestamp + (_expectedDaysToDelivery * 1 days));
    }

    function finalizeShipmentStatus(address _vendor, uint256 _index, bool _isDefective) external {
        require(msg.sender == qualityAuditor, "Unauthorized");
        Delivery storage d = vendorDeliveries[_vendor][_index];
        require(!d.completed, "Shipment already processed");

        d.actualTime = block.timestamp;
        d.isDefective = _isDefective;
        d.completed = true;

        emit DeliveryUpdated(_vendor, _isDefective, block.timestamp);
    }

    function getVendorScore(address _vendor) external view returns (uint256 punctualDeliveries, uint256 defectiveDeliveries, uint256 total) {
        Delivery[] memory list = vendorDeliveries[_vendor];
        uint256 punctual = 0;
        uint256 defective = 0;

        for (uint256 i = 0; i < list.length; i++) {
            if (list[i].completed) {
                if (list[i].actualTime <= list[i].expectedTime) punctual++;
                if (list[i].isDefective) defective++;
            }
        }
        return (punctual, defective, list.length);
    }
}
