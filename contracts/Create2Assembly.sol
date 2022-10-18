//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Wallet {
    address public owner;
    uint public foo;

    constructor(address _owner, uint _foo) payable  {
        owner = _owner;
        foo = _foo;
    }
}

contract Factory {
    event Deployed(address addr, uint256 salt);

    function getCreationBytecode(address _owner, uint _foo) public pure returns (bytes memory) {
        bytes memory bytecode = type(Wallet).creationCode;

        return abi.encodePacked(bytecode, abi.encode(_owner, _foo));
    }

    // NOTE: call this function with bytecode from getCreationByteCode and a random salt
    function deploy(bytes memory bytecode, uint _salt) public {
        address addr;
        assembly {
            addr := create2(0, add(bytecode, 0x20), mload(bytecode), _salt)

            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }

        emit Deployed(addr, _salt);
    }
}