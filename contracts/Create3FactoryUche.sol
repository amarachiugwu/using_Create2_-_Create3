
// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import {Create3} from "./Lib.sol";

struct Work {
    uint8 number;
}

contract Factory {
    function deploy(bytes32 _salt) public payable returns(address _d)  {
        Work memory w = Work({number: 2});

        uint256 eth = 2 ether;

        _d = Create3.create3(
            _salt, 
            abi.encodePacked(
                type(Child).creationCode,
                abi.encode(
                    w
                )), eth
            );
    }



    function isMyChlid(bytes32 _salt, address _child) view public returns(bool isMine) {
        
        address mine = Create3.addressOf(_salt);

        if(mine == _child) {
            isMine = true;
        }
    }

    function AddressIsMine(bytes32 _salt) public view returns(address isMine) {
        isMine = Create3.addressOf(_salt);
    }

    function createSalt(string memory name) pure public returns(bytes32 r) {
        r = bytes32(abi.encodePacked(name));
    }
}

contract Child {
    Work w;
    constructor(Work memory _w) payable {
        w = _w;
    }
}