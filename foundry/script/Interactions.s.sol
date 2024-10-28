// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "script/HelperConfig.sol";
import {VRFCoordinatorV2_5Mock} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

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
        vm.startBroadcast();

        console.log("Your subscriptionId Id is : ", subId);
        console.log("Please update the subscriptionId in your HelperConfig.s.sol");
        return (subId, vrfCoordiantor);

    }

    function run() public {
        createSubscriptionUsingConfig();
    }
}