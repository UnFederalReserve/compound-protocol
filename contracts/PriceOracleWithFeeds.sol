pragma solidity ^0.5.16;

import "./PriceOracle.sol";
import "./CErc20.sol";
import "./ExponentialNoError.sol";
import "./Chainlink/AggregatorV3Interface.sol";

contract PriceOracleWithFeeds is PriceOracle, ExponentialNoError {
    /**
    * @notice Administrator for this contract
    */
    address public admin;

    /**
     * @notice Pending administrator for this contract
     */
    address payable public pendingAdmin;

    mapping(address => uint) prices;

    struct ChainlinkFeed {
        AggregatorV3Interface addr;
        uint multiplierMantissa;
    }

    mapping(address => ChainlinkFeed) chainlink_feeds;

    event PricePosted(address asset, uint previousPriceMantissa, uint requestedPriceMantissa, uint newPriceMantissa);
    event ChainlinkPriceFeedPosted(address asset, address feed);
    event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
    event NewAdmin(address oldAdmin, address newAdmin);

    constructor() public {
        admin = msg.sender;
    }

    function getUnderlyingPrice(CToken cToken) public view returns (uint) {
        address asset;
        if (cToken.isEther()) {
            asset = address(0);
        } else {
            asset = address(CErc20(address(cToken)).underlying());
        }
        ChainlinkFeed storage chainlink_feed = chainlink_feeds[asset];
        if (address(chainlink_feed.addr) != address(0)) {
            (uint80 roundID, int price, uint startedAt, uint updatedAt, uint80 answeredInRound) = chainlink_feed.addr.latestRoundData();
            require(updatedAt != 0 && answeredInRound == roundID, "price isn't from the current round");
            require(price >= 0, "price can't be negative");
            return mul_(uint(price), chainlink_feed.multiplierMantissa);
        }
        return prices[asset];
    }

    function setUnderlyingPrice(CToken cToken, uint underlyingPriceMantissa) public {
        // Check caller is admin
        require(msg.sender == admin, "only admin can set price");

        address asset = address(CErc20(address(cToken)).underlying());
        emit PricePosted(asset, prices[asset], underlyingPriceMantissa, underlyingPriceMantissa);
        prices[asset] = underlyingPriceMantissa;
    }

    function setDirectPrice(address asset, uint price) public {
        // Check caller is admin
        require(msg.sender == admin, "only admin can set price");

        emit PricePosted(asset, prices[asset], price, price);
        prices[asset] = price;
    }

    // v1 price oracle interface for use as backing of proxy
    function assetPrices(address asset) external view returns (uint) {
        ChainlinkFeed storage chainlink_feed = chainlink_feeds[asset];
        if (address(chainlink_feed.addr) != address(0)) {
            (uint80 roundID, int price, uint startedAt, uint updatedAt, uint80 answeredInRound) = chainlink_feed.addr.latestRoundData();
            require(updatedAt != 0 && answeredInRound == roundID, "price isn't from the current round");
            require(price >= 0, "price can't be negative");
            return mul_(uint(price), chainlink_feed.multiplierMantissa);
        }
        return prices[asset];
    }

    /**
    * @notice Set chainlink price feed for the asset.
    * @param asset The address of the underlying asset
    * @param feed The address of the chainlink price feed
    * @param multiplierMantissa Multiplier to adjust the price feed decimals to the decimals expected by the comptroller. Usually 1e(18-asset.decimals) * 1e(18-feed.decimals)
    */
    function setDirectChainlinkFeed(address asset, AggregatorV3Interface feed, uint multiplierMantissa) public {
        // Check caller is admin
        require(msg.sender == admin, "only admin can set price");

        emit ChainlinkPriceFeedPosted(asset, address(feed));
        chainlink_feeds[asset] = ChainlinkFeed({addr: feed, multiplierMantissa: multiplierMantissa});
    }

    /**
    * @notice Set chainlink price feed for the CToken.
    * @param cToken The address of the CToken
    * @param feed The address of the chainlink price feed
    * @param multiplierMantissa Multiplier to adjust the price feed decimals to the decimals expected by the comptroller. Usually 1e(18-asset.decimals) * 1e(18-feed.decimals)
    */
    function setUnderlyingChainlinkFeed(CToken cToken, AggregatorV3Interface feed, uint multiplierMantissa) public {
        // Check caller is admin
        require(msg.sender == admin, "only admin can set price");

        setDirectChainlinkFeed(address(CErc20(address(cToken)).underlying()), feed, multiplierMantissa);
    }

    /**
      * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
      * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
      * @param newPendingAdmin New pending admin.
      */
    function _setPendingAdmin(address payable newPendingAdmin) external {
        // Check caller = admin
        require(msg.sender == admin, "unauthorized");

        // Save current value, if any, for inclusion in log
        address oldPendingAdmin = pendingAdmin;

        // Store pendingAdmin with value newPendingAdmin
        pendingAdmin = newPendingAdmin;

        emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
    }

    /**
      * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
      * @dev Admin function for pending admin to accept role and update admin
      */
    function _acceptAdmin() external {
        // Check caller is pendingAdmin and pendingAdmin ≠ address(0)
        require(msg.sender == pendingAdmin && msg.sender != address(0), "unauthorized");

        // Save current values for inclusion in log
        address oldAdmin = admin;
        address oldPendingAdmin = pendingAdmin;

        // Store admin with value pendingAdmin
        admin = pendingAdmin;

        // Clear the pending value
        pendingAdmin = address(0);

        emit NewAdmin(oldAdmin, admin);
        emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
    }

}
