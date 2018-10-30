
// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "../crowdfund/Crowdfund.sol";
import "../crowdfund/distribution/CrowdfundFee.sol";
import "../crowdfund/validation/FreezableCrowdfund.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

/**
 * @title CrowdfundFeeFreezableTemplate
 * @dev CrowdfundFeeTemplate Template to deploy to Zeus Network. Each cause can use this template.
 *  Wallet will be the destination of the funds and Wallet Fee the destination of fees. In all eth smartcontract with Crowdfee inheritance we will charge  a fee of 1% .
 * If Zeus Team see that the crowdfund is not legit anymore finding problems with the cause, it will freeze all the donations 
 *
 */

contract CrowdfundFeeFreezableTemplate is CrowdfundFee, FreezableCrowdfund {
    constructor(
        address wallet,
        address walletFee
        )   
        CrowdfundFee(walletFee)
        Crowdfund(wallet)
        public {
            
    }
 
}