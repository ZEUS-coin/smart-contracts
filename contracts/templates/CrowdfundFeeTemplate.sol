
// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "../crowdfund/Crowdfund.sol";
import "../crowdfund/distribution/CrowdfundFee.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

/**
 * @title CrowdfundFeeTemplate
 * @dev CrowdfundFeeTemplate Template to deploy to Zeus Network. Each cause can use this template.
 *  Wallet will be the destination of the funds. In all eth smartcontract with Crowdfee inheritance we will charge
 * a fee of 1% 
 */

contract CrowdfundFeeTemplate is CrowdfundFee {
    constructor(
        address wallet,
        address walletFee
        )   
        CrowdfundFee(walletFee)
        Crowdfund(wallet)
        public {
            
    }
 
}