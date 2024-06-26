//SPDX-License-Indentifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";



contract FundMeTest is Test{

address USER= makeAddr("user");
uint256 constant SEND_VALUE=0.1 ether;
uint256 constant STARTING_BALANCE=10 ether;
uint256 constant GAS_PRICE=1;
FundMe fundMe;

function setUp() external{
    DeployFundMe deployFundMe=new DeployFundMe();
fundMe=deployFundMe.run();
vm.deal(USER, STARTING_BALANCE);

//fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);

}

function testMinimumDollarIsFive() public view{
assertEq(fundMe.MINIMUM_USD(), 5e18);
}


function testOwnerIsMsgSender() view public{
    console.log(fundMe.getOwner());
    console.log(msg.sender);

    assertEq(fundMe.getOwner(), msg.sender);
   }

   function testPriceFeedVersionIsAccurate() view public{
    uint256 version= fundMe.getVersion();
    assertEq(version, 4);
   }

    function testFundFailsWithoutEnoughETH() public{
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public{
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountfunded=fundMe.getAddressToAmountFunded(USER);
        assertEq(SEND_VALUE,amountfunded);
        
        address fundingAddress=fundMe.getFunders(0);
         assertEq(fundingAddress , USER);

    }

    function testAddsFunderToarrayOfFunders() public{
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getFunders(0);
        assertEq(funder, USER);
    }

    

modifier funded(){
    vm.prank(USER);
    fundMe.fund{value: SEND_VALUE}();
    _;
}

    function testOnlyOwnerCanWithdraw() public{
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }
function testWithdrawWithASingleFunder() public{
        vm.prank(fundMe.getOwner());
        fundMe.fund{value: SEND_VALUE}();
        assertEq(fundMe.getAddressToAmountFunded(fundMe.getOwner()), SEND_VALUE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        uint256 amountFundedByUser=fundMe.getAddressToAmountFunded(fundMe.getOwner());
        assertEq(0, amountFundedByUser);
    }

    function testWithDrawWithASingleFunder() public funded{
        //Arrange
      uint256 startingOwnerBalance = fundMe.getOwner().balance;
      uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
    //    uint256 gasStart=gasleft(); //1000
    //    vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner()); // c: 200
        fundMe.withdraw();      
        //////////////////////////GAS
    //    uint256 gasEnd = gasleft(); //800

         //uint256 gasUsed=gasStart-gasEnd * tx.gasprice;
   //     uint256 gasUsedEth=gasStart-gasEnd * tx.gasprice;
        ////////////////////////////////GAS

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance+startingOwnerBalance, endingOwnerBalance);

    }


    function testWithdrawFromMultipleFunders() public funded{
        uint160 numberOfFunders=10;
        uint160 startingFunderIndex=1;
        for(uint160 i=startingFunderIndex;i<numberOfFunders; i++){
        //vm.prank
        //vm.deal
        //fund the fundMe
        hoax(address(i),SEND_VALUE);
        fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        //Assert
        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance+startingOwnerBalance==fundMe.getOwner().balance);
    }


function testWithdrawFromMultipleFundersCheaper() public funded{
        uint160 numberOfFunders=10;
        uint160 startingFunderIndex=1;
        for(uint160 i=startingFunderIndex;i<numberOfFunders; i++){
        //vm.prank
        //vm.deal
        //fund the fundMe
        hoax(address(i),SEND_VALUE);
        fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //act
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        //Assert
        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance+startingOwnerBalance==fundMe.getOwner().balance);
    }

}
