require('dotenv').config();
const Web3 = require("web3");
const web3 = new Web3();
const WalletProvider = require("truffle-hdwallet-provider");
const Wallet = require('ethereumjs-wallet');
var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "old address announce erode elite pause unable antenna pass cliff carpet want";

var mainNetPrivateKey = new Buffer("d17049230602ca1819e0e246af67cd2c49f43ca784d79f8df1116561ccd16a3f", "hex");
var mainNetWallet = Wallet.fromPrivateKey(mainNetPrivateKey);
var mainNetProvider = new WalletProvider(mainNetWallet, "https://mainnet.infura.io/");

var ropstenPrivateKey = new Buffer("d17049230602ca1819e0e246af67cd2c49f43ca784d79f8df1116561ccd16a3f", "hex");
var ropstenWallet = Wallet.fromPrivateKey(ropstenPrivateKey);
var ropstenProvider = new WalletProvider(ropstenWallet, "https://ropsten.infura.io/");
var infura_apikey = "bX5QyaHpl22GJJzO23WI"; // https://ropsten.infura.io/bX5QyaHpl22GJJzO23WI


module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 8545,
            network_id: "*", // Match any network id
            gas: 6712388
        },
        ropsten: {
            provider: function() {
                return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/bX5QyaHpl22GJJzO23WI")
            },
            gas: 5000000,
            gasPrice: web3.toWei("100", "gwei"),
            network_id: 3
        },
        mainnet: {
            provider: mainNetProvider,
            gas: 6600000,
            gasPrice: web3.toWei("20", "gwei"),
            network_id: "1",
        },
        solc: {
            optimizer: {
                enabled: true,
                runs: 200
            }
        }
    }
};
