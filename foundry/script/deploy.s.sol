// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script} from "../../foundrylib/lib/forge-std/src/Script.sol";
import {SimpleStorage} from "../src/simpleStorage.sol";

contract DeploySimpleStorage is Script {
    function run() external returns (SimpleStorage) {
        vm.startBroadcast();

        SimpleStorage simpleStorage = new SimpleStorage();

        vm.stopBroadcast();
        return simpleStorage;
    }
}