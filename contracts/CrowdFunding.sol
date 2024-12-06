// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    constructor() {}

    struct Campaign {
        address owner;
        string title;
        string description;
        uint target;
        uint deadline;
        uint amount;
        string image;
        address[] donators;
        uint[] donations;
    }

    mapping(uint => Campaign) public campaigns;

    uint public numberOfCampaigns = 0;

    function createCampaign(address _owner, string memory _title, string memory _description, uint _target, uint _deadline, string memory _image) public returns (uint){
        Campaign storage campaign = campaigns[numberOfCampaigns];

        require(campaign.deadline < block.timestamp, "The deadline should be a date in the future");

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amount = 0;
        campaign.image = _image;

        numberOfCampaigns++;
        
        return numberOfCampaigns - 1;
    }
    function donateToCampaign(uint _id) public payable {
        uint amount = msg.value;

        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool s,) = payable(campaign.owner).call{value:amount}("");

        if(s){
            campaign.amount = campaign.amount + amount;
        }

    }
    function getDonators(uint _id)view public returns(address[] memory, uint256[] memory){
        return (campaigns[_id].donators, campaigns[_id].donations);
    }
    function getCampaigns()public view returns(Campaign[] memory){
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for (uint256 i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
        }
        return allCampaigns;
    }
}
