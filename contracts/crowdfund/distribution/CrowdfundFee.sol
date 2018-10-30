// solium-disable linebreak-style
pragma solidity ^0.4.24;


import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "../Crowdfund.sol";

/**
 * @title CrowdfundFee
 * @dev CrowdfundFee is adding fee's to each donation in the smartcontract
 */
contract CrowdfundFee is Crowdfund {
    using SafeMath for uint256;
    // Address where fee funds are forward
    address private _walletFee;

    // Amount of fee wei raised
    uint256 private _feeRaised;

    // Amount of fee rate
    uint256 private _feeRate;

    /**
    * @dev 
    * @param wallet Address where collected funds will be forwarded to
    */
    constructor(address wallet) public {
        require(wallet != address(0));
        _walletFee = wallet;
        _feeRate = 1000000; // decimals 6. 1% fee by default
    }

    // -----------------------------------------
    // CrowdfundFee external interface
    // -----------------------------------------

    /**
    * @return the address where funds are collected.
    */
    function walletFee() public view returns(address) {
        return _walletFee;
    }
 
    /**
    * @return the mount of fee wei raised.
    */
    function feeRaised() public view returns (uint256) {
        return _feeRaised;
    }
    /**
    * @return the mount of fee rate.
    */
    function feeRate() public view returns (uint256) {
        return _feeRate;
    }

    /**
    * @dev Adding a fee to the contract
    */
    function _processFunds(address beneficiary, uint256 weiAmount) internal {
        uint256 fee = weiAmount.mul(feeRate()).div(100000000);
        uint256 amount = weiAmount.sub(fee);
        _feeRaised = _feeRaised.add(fee);
        _walletFee.transfer(fee);
        super._processFunds(beneficiary, amount);
    }
  
}