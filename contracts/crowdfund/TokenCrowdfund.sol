
// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";

/**
 * @title TokenCrowdfund
 * @dev TokenCrowdfund is a base contract for managing for managing donations,
 * allowing donators to donate tokens to a cause. This contract implements
 * such functionality in its most fundamental form and can be extended to provide additional
 * functionality and/or custom behavior.
 * The external interface represents the basic interface for purchasing tokens, and conform
 * the base architecture for crowdfunds. They are *not* intended to be modified / overridden.
 * The internal interface conforms the extensible and modifiable surface of crowdfunds. Override
 * the methods to add functionality. Consider using 'super' where appropriate to concatenate
 * behavior.
 */
contract TokenCrowdfund{
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
      // Address where funds are collected
    address private _wallet;
    // The token to collect
    IERC20 private _token;
    // Amount of token raised
    uint256 private _tokenRaised;
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
    * @param token Address of the token collected
    */
    constructor(IERC20 token, address wallet) public {
        require(token != address(0));
        require(wallet != address(0));
        _wallet = wallet;
        _token = token;
    }

    // -----------------------------------------
    // TokenCrowdfund external interface
    // -----------------------------------------
     /**
    * @return the address where funds are collected.
    */
    function wallet() public view returns(address) {
        return _wallet;
    }
    /**
    * @return the token being sold.
    */
    function token() public view returns(IERC20) {
        return _token;
    }
    /**
    * @return the mount of wei raised.
    */
    function tokenRaised() public view returns (uint256) {
        return _tokenRaised;
    }

    /**
    * @dev low level add fund ***DO NOT OVERRIDE***
    * @param beneficiary Address receiving the donations
    * @param amount Amount of tokens
    */
    function addTokenFund(address beneficiary, uint256 amount) public payable {

        _preValidateFund(beneficiary, amount);

        // update state
        _tokenRaised = _tokenRaised.add(amount);

        emit FundsAdded(
            msg.sender,
            amount
        );

        _updateFundState(beneficiary, amount);

        _forwardFunds(beneficiary, amount);
        _postValidateFund(beneficiary, amount);
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
        require(_token.allowance(beneficiary, _wallet) == weiAmount);
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
    function _forwardFunds(address beneficiary, uint256 amount) internal {
        _token.safeTransferFrom(beneficiary, _wallet, amount);
    }


}