// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;
    uint256 public BLOCK_ID = block.chainid;

    function fundFundMe(address mostRecentlyDeployed, address USER) public {
        if (USER != address(0)) {
            vm.prank(USER);
            FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        } else {
            FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        }

        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        console.log("this is the chain ID: %s", BLOCK_ID);
        vm.startBroadcast();
        fundFundMe(mostRecentlyDeployed, address(0));
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        withdrawFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}
