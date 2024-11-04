// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "script/HelperConfig.sol";
import {VRFCoordinatorV2_5Mock} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {LinkToken} from "test/mocks/link.sol";
import {CodeConstants} from  "script/HelperConfig.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract CreateSubscription is Script {

    function createSubscriptionUsingConfig() public returns (uint256, address) {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
        (uint256 subId , ) = createSubscription(vrfCoordinator);
        return (subId, vrfCoordinator);
    }

    function createSubscription(address vrfCoordiantor) public returns (uint256, address) {
        console.log("Create subcription on chain Id : ", block.chainid);
        vm.startBroadcast();
        uint256 subId = VRFCoordinatorV2_5Mock(vrfCoordiantor).createSubscription();
        vm.stopBroadcast();

        console.log("Your subscriptionId Id is : ", subId);
        console.log("Please update the subscriptionId in your HelperConfig.s.sol");
        return (subId, vrfCoordiantor);

    }

    function run() public {
        createSubscriptionUsingConfig();
    }
}

contract FundSubscription is Script, CodeConstants {
    uint256 public constant FUND_AMOUNT = 3 ether;
    
    function fundSubscriptionUsingConfig() public {
        HelperConfig helperConfig = new HelperConfig();
        address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
        uint256 subscriptionId = helperConfig.getConfig().subscriptionId;
        address linkToken = helperConfig.getConfig().link;
        fundSubscription(vrfCoordinator, subscriptionId, linkToken);

    }

    function fundSubscription(address vrfCoordinator, uint256 subscriptionId, address linkToken) public {
        console.log("Funding subscription: ", subscriptionId);
        console.log("Using vrfcoordinator: ", vrfCoordinator);
        console.log("On chainId: ", block.chainid);

        if (block.chainid == LOCAL_CHAIN_ID){
            vm.startBroadcast();
            VRFCoordinatorV2_5Mock(vrfCoordinator).fundSubscription(subscriptionId, FUND_AMOUNT * 100);
            vm.stopBroadcast();
        } else {
            vm.startBroadcast();
            LinkToken(linkToken).transferAndCall(vrfCoordinator, FUND_AMOUNT, abi.encode(subscriptionId));
            vm.stopBroadcast();
        }
    }

    function run() public {
        fundSubscriptionUsingConfig();
    }

}

    contract AddConsumer is Script {
        function addConsumnerUsingConfig(address mostRecentlyDeployed) public {
            HelperConfig helperConfig = new HelperConfig();
            uint256 subId = helperConfig.getConfig().subscriptionId;
            address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
            addConsumer(mostRecentlyDeployed, vrfCoordinator, subId);
        }

        function addConsumer(address contractToAddVrf, address vrfCoordinator, uint256 subId) public {
            console.log("Adding consumer contract: ", contractToAddVrf);
            console.log("To vrfCoorinator: ", vrfCoordinator);
            console.log("On chainId: ", block.chainid);
            vm.startBroadcast();
            VRFCoordinatorV2_5Mock(vrfCoordinator).addConsumer(subId, contractToAddVrf);
            vm.stopBroadcast();
        }

        function run() external {
            address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("Raffle", block.chainid);
            addConsumnerUsingConfig(mostRecentlyDeployed);
        }
    }