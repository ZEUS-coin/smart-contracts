
// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";

/**
 * @title TokenCrowdfund
 * @dev TokenCrowdfund is a base contract for managing token donations,
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
    event FundsWithdraw(
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
    * @return the token being donated.
    */
    function token() public view returns(IERC20) {
        return _token;
    }
    /**
    * @return the mount of token raised.
    */
    function tokenRaised() public view returns (uint256) {
        return _tokenRaised;
    }

    /**
    * @dev low level add fund ***DO NOT OVERRIDE***
    */
    function withdrawFunds() public {

        _preValidateFund();
        _withdrawFunds();
        // update state
    }
  
     // -----------------------------------------
    // Internal interface (extensible)
    // -----------------------------------------

    /**
    * @dev Validation of an incoming funds. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdfund to extend their validations.
    * Example from HolderCrowdfund.sol's _preValidatePurchase method:
    *   super._preValidatePurchase(beneficiary, weiAmount);
    *   require(weiRaised().add(weiAmount) <= cap);
    */
    function _preValidateFund(
    )
        internal
    {
      
    }

    /**
    * @dev Withdraw funds to destination wallet and update token reaised
    */
    function _withdrawFunds() internal {
        uint256 amount = _token.balanceOf(address(this));
        _tokenRaised = _tokenRaised.add(amount);
        _token.safeTransfer(_wallet, amount);
        emit FundsWithdraw(
            msg.sender,
            amount
        );
    }


}