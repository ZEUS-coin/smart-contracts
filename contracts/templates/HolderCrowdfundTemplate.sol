
// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "../crowdfund/Crowdfund.sol";
import "../crowdfund/validation/HolderCrowdfund.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

/**
 * @title HolderCrowdfundTemplate
 * @dev Holder Crowdfund Template to deploy to Zeus Network. Each cause will use this template.
 * token will be the Zeus token, the holding is the minimum amount necessary to hold Zeus token to being able to
 * donate. wallet will be the destination of the funds. 
 */

contract HolderCrowdfundTemplate is  HolderCrowdfund {
    constructor(
        IERC20 token,
        uint256 holding, 
        address wallet
        )   
        HolderCrowdfund(token, holding)
        Crowdfund(wallet)
        public {
            
    }
 
}
