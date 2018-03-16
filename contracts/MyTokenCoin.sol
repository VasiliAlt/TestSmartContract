pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";

contract MyTokenCoin is MintableToken {

    string public constant name = "AR_Utility_Token";
    string public constant symbol = "AR";
    uint32 public constant decimals = 0;
    uint256 public INITIAL_SUPPLY = 586200000;

    function MyTokenCoin() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
    }

}

