// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "./Ownable.sol";

/**
 * @title PropertyManager
 * @dev Property contract
 */

contract PropertyManager is Ownable {
    // Variables
    uint public propertiesForSale = 0;
    Property[] public properties;

    // Mapping
    mapping (uint => address) propertyToOwner;
    mapping (address => uint) ownerPropertiesCount;

    // Events
    event NewProperty(uint id, string title, string info, bool forSale, uint price);

    // Structs
    struct Property {
        uint id;
        string title;
        string info;
        bool forSale;
        uint price;
    }

    // Modifiers
    modifier onlyPropertyOwner(uint id){
        require(msg.sender == propertyToOwner[id], "Only property owner can call this function.");
        _;
    }

    // Setters and Getters
    function changeTitle(uint id, string memory newTitle) external onlyPropertyOwner(id){
        properties[id].title = newTitle;
    }

    function changeInfo(uint id, string memory newInfo) external onlyPropertyOwner(id){
        properties[id].info = newInfo;
    }

    function changePrice(uint id, uint newPrice) external onlyPropertyOwner(id){
        properties[id].price = newPrice;
    }

    function toggleForSale(uint id) public onlyPropertyOwner(id){
        if (properties[id].forSale){
            properties[id].forSale = false;
            propertiesForSale--;
        } else {
            properties[id].forSale = true;
            propertiesForSale++;
        }
    }

    // Functions
    function createProperty(string memory title, string memory info, bool forSale, uint price) public {
        uint id = properties.length;
        properties.push(Property(id, title, info, forSale, price));
        propertyToOwner[id] = msg.sender;
        ownerPropertiesCount[msg.sender]++;
        emit NewProperty(id, title, info, forSale, price);
        if (forSale){
            propertiesForSale++;
        }
    }

    function buyProperty(uint id) payable external {
        require(properties[id].forSale, "Property is not for sale.");
        require(msg.value == properties[id].price, "Value and price are not equal.");

        address oldOwner = propertyToOwner[id];
        address newOwner = msg.sender;

        (bool sent,) = oldOwner.call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        propertyToOwner[id] = newOwner;
        ownerPropertiesCount[oldOwner]--;
        ownerPropertiesCount[newOwner]++;
        toggleForSale(id);

    }

    // View Functions
    function getForSaleProperties() external view returns (Property[] memory) {
        Property[] memory forSaleProperties = new Property[](propertiesForSale);
        uint counter = 0;
        for (uint i = 0; i < properties.length; i++){
            Property memory prop = properties[i];
            if (prop.forSale) {
                forSaleProperties[counter] = prop;
                counter++;
            }
        }
        return forSaleProperties;
    }

    function getOwnerProperties(address owner) public view returns (Property[] memory) {
        Property[] memory myProperties = new Property[](ownerPropertiesCount[owner]);
        uint counter = 0;
        for (uint i = 0; i < properties.length; i++){
            Property memory prop = properties[i];
            if (propertyToOwner[i] == owner) {
                myProperties[counter] = prop;
                counter++;
            }
        }
        return myProperties;
    }

    function getMyProperties() external view returns (Property[] memory) {
        return getOwnerProperties(msg.sender);
    }

    function getAllProperties() external view returns (Property[] memory) {
        return properties;
    }
}