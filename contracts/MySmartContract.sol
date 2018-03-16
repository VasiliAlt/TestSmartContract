pragma solidity ^0.4.18;

//import 'github.com/OpenZeppelin/zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol';
//import 'github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';
//import 'github.com/OpenZeppelin/zeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol';

import 'zeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol';
import 'zeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol';
import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import './MyTokenCoin.sol';
contract MySmartContract is CappedCrowdsale, RefundableCrowdsale {

    mapping(address => uint) public balances;

    uint public startTime;
    uint public period;
    uint256 endTime ;
    uint256 rate;
    address wallet ;
    bool isFinalized;
    bool public initialized = false;
    MintableToken token = new MyTokenCoin();

    enum CrowdsaleStage { PreICO, ICO }
    CrowdsaleStage public stage = CrowdsaleStage.PreICO;
    // =============

    // ARGO Token Distribution
    // =============================
    uint256 public maxTokens = 586200000; // There will be total 586,2 mln  Tokens
    uint256 public tokensForEcosystem = 11500000;//11,5 mln –promotional reserves to early users and investors;
    uint256 public tokensForTeam = 91900000;//91,9 mln for the team
    uint256 public tokensForBounty = 57500000; // 57,5 mln
    uint256 public totalTokensForSale = 402300000; // 402,300,000 will be sold in Crowdsale
    uint256 public totalTokensForSaleDuringPreICO = 33200000; // 33,200,000 out of 586,2 mln ARGO will be sold during PreICO
    // ==============================

    // Amount Wei raised in PreICO
    // ==================
    uint256 public totalWeiRaisedDuringPreICO =0;
    // ===================

    // Events
    event EthTransferred(string text);
    event EthRefunded(string text);
    event BoughtTokens(address indexed to, uint256 value);

    modifier whenSaleIsActive() {
        // Check if sale is active
        assert(isActive());
        _;
    }

    function initialize() public onlyOwner {
        require(initialized == false); // Can only be initialized once
        initialized = true;
    }
    // Constructor
    // ============
    function MySmartContract(uint256 _openingTime, uint256 _closingTime, uint256 _rate, address _wallet, uint256 _goal, uint256 _cap)
        CappedCrowdsale(_cap)
        FinalizableCrowdsale()
        RefundableCrowdsale(_goal)
        TimedCrowdsale(_openingTime, _closingTime)
        Crowdsale(_rate, _wallet, token) public
    {

        startTime = _openingTime;
        endTime = _closingTime;
        rate = _rate;
        setCrowdsaleStage(CrowdsaleStage.PreICO);
        isFinalized = false;

    }

    function setCurrentRate(uint256 _rate) private {
        rate = _rate;
    }
    // Change Crowdsale Stage. Available : PreICO, ICO
    function setCrowdsaleStage(CrowdsaleStage _stage) public onlyOwner {

        stage = _stage;
        if (stage == CrowdsaleStage.PreICO) {
            setCurrentRate((uint256)(1 ether)/16000000000000);
        } else if (stage == CrowdsaleStage.ICO) {
            setCurrentRate((uint256)(1 ether)/23000000000000);
        }
    }
    // Override to indicate when the crowdsale ends and does not accept any more contributions
    // Checks endTime by default, plus cap from CappedCrowdsale
    function isActive() public returns (bool) {
        return ((now < endTime) && (goalReached() == false) && (now > startTime));
    }

    // Token Purchase
    // =========================
/*    function buyTokens() external payable whenSaleIsActive{

        uint tokensThatWillBeMintedAfterPurchase = getTokenAmount(msg.value);

        if ((token.totalSupply() + tokensThatWillBeMintedAfterPurchase > totalTokensForSaleDuringPreICO))
        {
            msg.sender.transfer(msg.value); // Check for MaxTokenLimit & Refund them
            EthRefunded("PreICO MAX Tokens Amount Reached");
            return;
        }
        balances[this] -= tokensThatWillBeMintedAfterPurchase;
        balances[msg.sender] = balances[msg.sender].add(msg.value);
        BoughtTokens(msg.sender, tokensThatWillBeMintedAfterPurchase);
        buyTokens(msg.sender);
        forwardFunds();
        totalWeiRaisedDuringPreICO = totalWeiRaisedDuringPreICO.add(msg.value);

    }
*/

    function _getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
        uint256 tokensThatWillBeMintedAfterPurchase = rate.mul(weiAmount);
        uint bonusTokens = 0;
        if (stage == CrowdsaleStage.PreICO) {

            if(now <= startTime + (2 days)) {
                bonusTokens = tokensThatWillBeMintedAfterPurchase.div(100).mul(50);
            } else if(now >= startTime + 3 days && now < startTime + 4 days) {
                bonusTokens = tokensThatWillBeMintedAfterPurchase.div(100).mul(40);
            } else if(now >= startTime + 5 days && now < startTime + 6 days) {
                bonusTokens = tokensThatWillBeMintedAfterPurchase.div(100).mul(30);
            } else if(now >= startTime + 7 days && now < startTime + 8 days) {
                bonusTokens = tokensThatWillBeMintedAfterPurchase.div(100).mul(20);
            }
        }
        return tokensThatWillBeMintedAfterPurchase.add(bonusTokens);
    }

    // Override to execute any logic once the crowdsale finalizes
    // Requires a call to the public finalize method, only after the sale hasEnded
    // Remember that super.finalization() calls the token finishMinting(),
    // so no new tokens can be minted after that
    function finalization() internal {

        super.finalization();
    }

    function finish(address _teamFund, address _ecosystemFund, address _bountyFund) public onlyOwner {
        require(!isFinalized);
        uint256 alreadyMinted = token.totalSupply();
        require(alreadyMinted < maxTokens);

        uint256 unsoldTokens = totalTokensForSale - alreadyMinted;
        if (unsoldTokens > 0) {
            tokensForEcosystem = tokensForEcosystem + unsoldTokens;
        }
        token.transfer(_teamFund,tokensForTeam);
        token.transfer(_ecosystemFund,tokensForEcosystem);
        token.transfer(_bountyFund,tokensForBounty);
        finalize();
    }

}