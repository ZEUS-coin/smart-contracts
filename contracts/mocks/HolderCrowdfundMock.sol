

// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "../crowdfund/Crowdfund.sol";
import "../crowdfund/validation/HolderCrowdfund.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

/**
 * @title HolderCrowdfundMock
 * @dev Holder Crowdfund testing mock
 */

contract HolderCrowdfundMock is  HolderCrowdfund {
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
