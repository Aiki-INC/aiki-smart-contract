// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Script, console } from "forge-std/Script.sol";
import { Aiki } from "../src/Aiki.sol";
import { AikiFactory } from "../src/AikiFactory.sol";
import { AikiToken } from "../src/AikiToken.sol";

contract AikiDeployScript is Script {
  Aiki public aiki;
  AikiFactory public aikiFactory;
  AikiToken public aikiToken;

  function setUp() public { }

  function run() public {
    vm.startBroadcast();

    // Deploy the main contracts
    aiki = new Aiki();
    aikiFactory = new AikiFactory();
    aikiToken = new AikiToken();

    console.log("Aiki deployed at:", address(aiki));
    console.log("AikiFactory deployed at:", address(aikiFactory));
    console.log("AikiToken deployed at:", address(aikiToken));

    vm.stopBroadcast();
  }
}
