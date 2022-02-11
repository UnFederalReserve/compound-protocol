pragma solidity ^0.5.16;

import "../../contracts/Unitroller.sol";

contract UnitrollerHarness is Unitroller {
    function isMember(address account) internal returns (bool) {
        return true;
    }
}
