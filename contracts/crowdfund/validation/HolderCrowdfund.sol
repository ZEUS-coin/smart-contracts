// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "../Crowdfund.sol";
/**
 * @title HolderCrowdfund
 * @dev Extension of Crowdfund with where only donators with pre determined token holding
 * can donate
 */
contract HolderCrowdfund is Crowdfund {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // The token holders
    IERC20 private _token;
    // The minimum amount to hold
    uint256 private _holding;


   /**
    * @dev 
    * @param token Address of the token which is need holds 
    */
    constructor(IERC20 token, uint256 holding) public {
        require(holding > 0);
        require(token != address(0));
        _holding = holding;
        _token = token;
    }

    /**
    * @return the token being holding.
    */
    function token() public view returns(IERC20) {
        return _token;
    }

    /**
    * @return the number of token holding that needs to donate funds to the cause
    */
    function holding() public view returns(uint256) {
        return _holding;
    }
    /**
    * @return the number of token holding that needs to donate funds to the cause
    */
    function holder() public view returns(bool) {
        return (_token.balanceOf(msg.sender) >= _holding);
    }

    function _preValidateFund(
        address beneficiary,
        uint256 weiAmount
    )
        internal
    {
        super._preValidateFund(beneficiary, weiAmount); 
        require(holder(), "You must be a holder");
    }

  
}