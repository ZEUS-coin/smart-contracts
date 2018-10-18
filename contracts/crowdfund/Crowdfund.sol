// solium-disable linebreak-style
pragma solidity ^0.4.24;


import "openzeppelin-solidity/contracts/math/SafeMath.sol";


/**
 * @title Crowdfund
 * @dev Crowdfund is a base contract for managing donations,
 * allowing donators to donate ether to a cause. This contract implements
 * such functionality in its most fundamental form and can be extended to provide additional
 * functionality and/or custom behavior.
 * The external interface represents the basic interface for purchasing tokens, and conform
 * the base architecture for crowdfunds. They are *not* intended to be modified / overridden.
 * The internal interface conforms the extensible and modifiable surface of crowdfunds. Override
 * the methods to add functionality. Consider using 'super' where appropriate to concatenate
 * behavior.
 */
contract Crowdfund {
    using SafeMath for uint256;
    // Address where funds are collected
    address private _wallet;

    // Amount of wei raised
    uint256 private _weiRaised;

    /**
    * Event for token purchase logging
    * @param donator who paid for the tokens
    * @param amount amount of tokens purchased
    */
    event FundsAdded(
        address indexed donator,
        uint256 amount
    );

    /**
    * @dev 
    * @param wallet Address where collected funds will be forwarded to
    */
    constructor(address wallet) public {
        require(wallet != address(0));
        _wallet = wallet;
    }

    // -----------------------------------------
    // Crowdfund external interface
    // -----------------------------------------

    /**
    * @dev fallback function ***DO NOT OVERRIDE***
    */
    function () external payable {
        addFund(msg.sender);
    }

    /**
    * @return the address where funds are collected.
    */
    function wallet() public view returns(address) {
        return _wallet;
    }

    /**
    * @return the mount of wei raised.
    */
    function weiRaised() public view returns (uint256) {
        return _weiRaised;
    }

    /**
    * @dev low level add fund ***DO NOT OVERRIDE***
    * @param beneficiary Address receiving the donations
    */
    function addFund(address beneficiary) public payable {

        uint256 weiAmount = msg.value;
        _preValidateFund(beneficiary, weiAmount);

        // update state
        _weiRaised = _weiRaised.add(weiAmount);

        emit FundsAdded(
            msg.sender,
            weiAmount
            );

        _updateFundState(beneficiary, weiAmount);

        _forwardFunds();
        _postValidateFund(beneficiary, weiAmount);
    }

    // -----------------------------------------
    // Internal interface (extensible)
    // -----------------------------------------

    /**
    * @dev Validation of an incoming funds. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdfund to extend their validations.
    * Example from HolderCrowdfund.sol's _preValidatePurchase method:
    *   super._preValidatePurchase(beneficiary, weiAmount);
    *   require(weiRaised().add(weiAmount) <= cap);
    * @param beneficiary Address performing the token purchase
    * @param weiAmount Value in wei involved in the purchase
    */
    function _preValidateFund(
        address beneficiary,
        uint256 weiAmount
    )
        internal
    {
        require(beneficiary != address(0));
        require(weiAmount != 0);
    }

    /**
    * @dev Validation of an executed donation fund. Observe state and use revert statements to undo rollback when valid conditions are not met.
    * @param beneficiary Address performing the fund donation
    * @param weiAmount Value in wei involved in the donation
    */
    function _postValidateFund(
        address beneficiary,
        uint256 weiAmount
    )
        internal
    {
        // optional override
    }
    /**
    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
    * @param beneficiary Address receiving the tokens
    * @param weiAmount Value in wei involved in the purchase
    */
    function _updateFundState(
        address beneficiary,
        uint256 weiAmount
    )
        internal
    {
        // optional override
    }
    /**
    * @dev Determines how ETH is stored/forwarded on donations.
    */
    function _forwardFunds() internal {
        _wallet.transfer(msg.value);
    }
}