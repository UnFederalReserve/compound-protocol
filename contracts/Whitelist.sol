pragma solidity ^0.5.16;

import "./WhitelistInterfaces.sol";

contract Whitelist is WhitelistInterface {
    function _addMembers(address[] memory _members) public returns (uint) {
        uint len = _members.length;

        for (uint i = 0; i < len; i++) {
            address _member = _members[i];

            if (!members[_member]) {
                members[_member] = true;
                emit MemberAdded(_member);
            }
        }

        return 0;
    }

    function _removeMembers(address[] memory _members) public returns (uint) {
        uint len = _members.length;

        for (uint i = 0; i < len; i++) {
            address _member = _members[i];

            if (members[_member]) {
                delete members[_member];
                emit MemberRemoved(_member);
            }
        }

        return 0;
    }
}
