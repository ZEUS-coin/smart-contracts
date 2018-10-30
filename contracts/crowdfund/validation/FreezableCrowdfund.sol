// solium-disable linebreak-style
pragma solidity ^0.4.24;


import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../Crowdfund.sol";
/**
 * @title HolderCrowdfund
 * @dev Extension of Crowdfund with where only donators with pre determined token holding
 * can donate
 */
contract FreezableCrowdfund is Crowdfund, Ownable {
    using SafeMath for uint256;

    bool private _freeze = false;

     /**
    * Event for when freeze state change
    * @param owner Who freezed the crowdfund
    * @param freezeState the new state of the crowdfund
    */
    event FreezedStateChanged (
        address indexed owner,
        bool freezeState
    );
    /**
    * @return the number of token holding that needs to donate funds to the cause
    */
    function isFreezed() public view returns(bool) {
        return _freeze;
    }

    function freezeDonations(bool freezeState) public onlyOwner{
        _freeze = freezeState;
        emit FreezedStateChanged (
            msg.sender,
            freezeState
        );
    }

    function _preValidateFund(
        address beneficiary,
        uint256 weiAmount
    )
        internal
    {
        require(!isFreezed(), "Donations are freezed");
        super._preValidateFund(beneficiary, weiAmount);     
    }

  
}