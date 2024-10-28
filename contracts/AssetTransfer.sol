// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract AssetTransfer {
    enum AssestStatus {Inactive, Active}

   struct Asset {
    uint256 id;
    string name;
    string description;
    address currentOwner;
    address[] ownershipHistory;
    AssestStatus status;
   }

   uint256 public assetCount = 0;
   mapping(uint256 => Asset) public assets;

   event RegisteredAsset(uint256 assestId, string name, string description, address owner);
   event OwnershipTransfered(uint256 assetId, address from, address to);

   modifier onlyOwner(uint256 assetId) {
    require(assets[assetId].currentOwner == msg.sender,"You are not the asset owner");

    _;
   }

    modifier isActive(uint256 assetId) {
    require(assets[assetId].status == AssestStatus.Active,"Asset is not active");

    _;
   }


    function registerAsset(string memory name, string memory description) external returns (uint256)  {
        assetCount += 1;
        uint256 newAssetId = assetCount;

        assets[newAssetId]= Asset({
            id: newAssetId,
            name : name,
            description : description,
            currentOwner : msg.sender,
            ownershipHistory : assets[newAssetId].ownershipHistory,
            status : AssestStatus.Active
        });

        assets[newAssetId]. ownershipHistory.push(msg.sender);

        emit RegisteredAsset(newAssetId ,name ,description ,msg.sender);
        return newAssetId;
        
    }

    
    function transferOwnership(uint256 assetId, address newOwner) external onlyOwner(assetId) isActive(assetId) {
        require(newOwner != address(0), "zero address not allowed");

        Asset storage asset = assets[assetId];
        address previousOwner = asset.currentOwner;
        asset.currentOwner = newOwner;
        asset.ownershipHistory.push(newOwner);

        emit OwnershipTransfered(assetId ,previousOwner ,newOwner);
    }

    function getOwnerShipHistory(uint256 assetId) external view returns(address[] memory){
        return assets[assetId].ownershipHistory;
    }

      function getAssetDetails(uint256 assetId) external view returns (uint256, string memory, address, address[] memory, AssestStatus) {
        Asset storage asset = assets[assetId];
        return (asset.id, asset.name, asset.currentOwner, asset.ownershipHistory, asset.status);
    }

    function getCurrentOwner(uint256 assetId) external view returns (address) {
    return assets[assetId].currentOwner;
 }

    

   
}