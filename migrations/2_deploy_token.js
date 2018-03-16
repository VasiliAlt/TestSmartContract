var Token = artifacts.require("./MyTokenCoin.sol");
var Contract = artifacts.require('./MySmartContract.sol');


module.exports = function(deployer, network, accounts) {

    const openingTime = web3.eth.getBlock('latest').timestamp + 2; //1521201600;// 1521028800;//14.03.2018
    const closingTime = 1522627140;//01.04.2018
    const rate = Math.round(1 / 0.000016);// rate for preICO stage
    const wallet = accounts[0];
    const cap = 1000000000000000000;//1 eth
    const goal = 31000000000000000000;//31 eth
    //deployer.deploy(Token);
    //deployer.deploy(Contract, openingTime, closingTime, ethRate, wallet, goal, cap);

        deployer.deploy(Token);
        Token.deployed().then(function(instance) {
            deployer.deploy(Contract, openingTime, closingTime, rate, wallet, goal, cap);
        });
    };


