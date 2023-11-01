//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_ETHER = 100 ether;

    function setUp() external {
        DeployOurToken deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender); // This is the owner of our token

        ourToken.transfer(bob, STARTING_ETHER); // In this function we as the msg.sender are giving bob a starting ether
            //by default the transfer function has 3 parameter with the first as the msg.sender
    }

    function testBobBalance() public view {
        assert(STARTING_ETHER == ourToken.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        // Arrange
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend tokens on his behalf
        vm.prank(bob);

        // Act
        ourToken.approve(alice, initialAllowance);

        //simulates alice to transfer

        uint256 transferAmount = 500;
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);
        //if we specify or use the transfer function the first parameter will default to the msg.sender address and so we would transfer
        // from our address rather than bob address

        // Assert
        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_ETHER - transferAmount);
    }
}
