// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";


contract UltimateFaceOff {
    using MessageHashUtils for bytes32;
    using ECDSA for bytes32;
    using Strings for uint256;

    error NoFaceNoPlace();

    // Mapping to store addresses
    mapping(address => bool) public winners;

    // Function to save an address if the signature is valid
    function participate(bytes memory signature) public {
        // Construct the message from msg.sender and a fixed string
        bytes32 message = keccak256(abi.encodePacked(msg.sender, "calyptus"));
        bytes32 ethSignedMessage = message.toEthSignedMessageHash();

        // Recover the signer address from the signature
        address recoveredAddress = ethSignedMessage.recover(signature);

        // Check if the address starts with the specified prefix
        if (!startsWith(toAsciiString(recoveredAddress), "0xface")) {
            revert NoFaceNoPlace();
        }
        // Save the msg.sender address in the mapping
            winners[msg.sender] = true;
    }

    // Function to convert address to string
    function toAsciiString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(42);
        s[0] = "0";
        s[1] = "x";
        for (uint i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2*i + 2] = char(hi);
            s[2*i + 3] = char(lo);
        }
        return string(s);
    }

    // Function to convert byte to character
    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }

    // Function to check if a string starts with a given prefix
    function startsWith(string memory fullString, string memory prefix) internal pure returns (bool) {
        bytes memory fullStringBytes = bytes(fullString);
        bytes memory prefixBytes = bytes(prefix);

        if (prefixBytes.length > fullStringBytes.length) {
            return false;
        }

        for(uint i = 0; i < prefixBytes.length; i++) {
            if (fullStringBytes[i] != prefixBytes[i]) {
                return false;
            }
        }

        return true;
    }
}