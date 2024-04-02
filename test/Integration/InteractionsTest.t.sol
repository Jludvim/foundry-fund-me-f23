//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTests is Test{
address USER= makeAddr("user");
uint256 constant SEND_VALUE=0.1 ether;
uint256 constant STARTING_BALANCE=1e18;
uint256 constant GAS_PRICE=1;
FundMe fundMe;


function setUp() external {
    DeployFundMe deploy= new DeployFundMe();
    fundMe=deploy.run();
    vm.deal(USER, STARTING_BALANCE);
}

function testUserCanFund() public{
FundFundMe fundFundMe= new FundFundMe();
fundFundMe.fundFundMe(address(fundMe));

WithdrawFundMe withdrawFundMe= new WithdrawFundMe();
withdrawFundMe.withdrawFundMe(address(fundMe));

assert(address(fundMe).balance==0);
}

}