//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Wallet {
    address public owner;

    constructor(address _owner) payable {
        owner = _owner;
    }
}

contract Factory {
    event Deployed(address addr, Wallet newAddr, bytes32 salt);

    function getCreationBytecode(address _owner) public pure returns (bytes memory) {
        bytes memory bytecode = type(Wallet).creationCode;

        return abi.encodePacked(bytecode, abi.encode(_owner));
    }

    // NOTE: call this function with bytecode from getCreationByteCode and a random salt
    function deploy(bytes memory bytecode, bytes32 _salt, address _owner) public {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(
            bytes1(0xFF), address(this), _salt, bytecode
        )))));


        Wallet newAddr = new Wallet{salt: _salt}(_owner);
        // require(address(newAddr) == addr);

        emit Deployed(addr, newAddr, _salt);
    }

    function genSalt (string memory _salt) external pure returns(bytes32 salt){
        salt = bytes32(abi.encodePacked(_salt));
    }
}