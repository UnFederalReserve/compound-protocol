pragma solidity ^0.5.16;

import "../../contracts/Comptroller.sol";
import "../../contracts/PriceOracle.sol";

contract ComptrollerWhitelistFree is Comptroller {
    function isMember(address account) internal returns (bool) {
        return true;
    }
}
