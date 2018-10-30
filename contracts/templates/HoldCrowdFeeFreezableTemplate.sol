
// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "../crowdfund/Crowdfund.sol";
import "../crowdfund/distribution/CrowdfundFee.sol";
import "../crowdfund/validation/FreezableCrowdfund.sol";
import "../crowdfund/validation/HolderCrowdfund.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

/**
 * @title HoldCrowdFeeFreezableTemplate
 * @dev HoldCrowdFeeFreezableTemplate Template to deploy to Zeus Network. Each cause will use this template.
 * Token will be the Zeus token, the holding is the minimum amount necessary to hold Zeus token to being able to
 * donate. Wallet will be the destination of the funds. WalletFee is the Zeus wallet where funds will be forward.
 *  In all eth smartcontracts with CrowdfundFee inheritance we will charge
 * a fee of 1% 
 */

contract  HoldCrowdFeeFreezableTemplate is HolderCrowdfund, CrowdfundFee, FreezableCrowdfund {
    constructor(
        IERC20 token,
        uint256 holding, 
        address wallet,
        address walletFee
        )   
        HolderCrowdfund(token, holding)
        CrowdfundFee(walletFee)
        Crowdfund(wallet)
        public {
            
    }
 
}