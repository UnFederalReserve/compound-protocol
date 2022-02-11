pragma solidity ^0.5.16;

contract WhitelistStorage {
    /**
     * @notice Mapping of account addresses who added to whitelist
     */
    mapping (address => bool) public members;
}

contract WhitelistInterface is WhitelistStorage {
    /*** Events ***/

    /**
     * @notice Event emitted when member are added to whitelist
     */
    event MemberAdded(address member);

    /**
     * @notice Event emitted when member are removed from whitelist
     */
    event MemberRemoved(address member);


    /*** Admin Functions ***/

    function _addMembers(address[] memory _members) public returns (uint);
    function _removeMembers(address[] memory _members) public returns (uint);
}
