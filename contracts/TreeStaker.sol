// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";
// import "./ExampleExternalContract.sol";

contract TreeStaker {

  event Stake(address,uint256);
  mapping ( address => uint256 ) public balances;
  uint256 public constant threshold = 1 ether;
  uint256 public deadline = block.timestamp + 72 hours;
  bool openForWithdraw;

//   ExampleExternalContract public exampleExternalContract;

//   constructor(address exampleExternalContractAddress) public {
//     //   exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
//   }

  // Collect funds in order to take future Dao choices
  function stake() public payable {
    balances[msg.sender] += msg.value;
    emit Stake(msg.sender,msg.value);
    console.log("deposit:  ");
  }  

  // After some `deadline` allow anyone to call an `execute()` function
  // call external contract,fund distribution between project supporters
  function execute()public {
    if (address(this).balance >=threshold && block.timestamp >=deadline){
    //   exampleExternalContract.complete{value: address(this).balance}();
    }
    
    if (address(this).balance <threshold && block.timestamp >=deadline){
      openForWithdraw=true;
    }
  }
  // if the `threshold` was not met, allow everyone to call a `withdraw()` function
  // meant to protect peoples funds when a goal is not met
  function withdraw() public { //address _to
    console.log("withdraw attempt");
    require(openForWithdraw,"you can't withdraww yet");
    uint256 userBalance = balances[msg.sender];
    require (userBalance > 0,"your balance needs to be more than zero");
    balances[msg.sender] = 0;
    (bool sent,) = msg.sender.call{value: userBalance}("");
    require(sent,"failed to withdraw");
  }

  // Add a `timeLeft()` view function that returns the time left before the deadline
  function timeLeft() public view returns (uint256){
    if(block.timestamp >= deadline){
      return 0;
    }
    return deadline - block.timestamp;
  }

  // receives Tokens and calls stake()
  receive() external payable {
    stake();
  }

}