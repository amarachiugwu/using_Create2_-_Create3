//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {Create3} from  "./Lib.sol";


contract Child {
  bytes32 public dna;
  struct Data{
    // uint256[] numbers;
    // bool in__;
    uint key;
  }
  
  mapping(address => Data) public data;

  
  constructor(Data memory _data, bytes32 salt) payable {
    dna = salt;
    data[msg.sender] = _data;
  }
}

contract Deployer {

  struct Data{
    // uint256[] numbers;
    // bool in__;
    uint key;
  }

  function deployChild(bytes32 salt, Data memory _data) payable external returns(address addr) {
    addr = Create3.create3(
      salt, 
      abi.encodePacked(
        type(Child).creationCode,
        abi.encode(
          _data,salt
        )
      ),
      2 ether
    );
  }


  function isMyChild(address child) external view returns (bool isChid) {
    bytes32 salt = Child(child).dna();
    assert(Create3.addressOf(salt) == child);
    isChid = true;
  }

  function getChild (bytes32 _salt) external view returns (address child){
    child = Create3.addressOf(_salt);
  }

  function genSalt (string memory _salt) external pure returns (bytes32 salt) {
    salt = bytes32(abi.encodePacked(_salt));
  }
}


