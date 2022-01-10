require("@nomiclabs/hardhat-waffle");

// The next line is part of the sample project, you don't need it in your
// project. It imports a Hardhat task definition, that can be used for
// testing the frontend.

const ALCHEMY_API_KEY = "Vj3tem8IEHDD5JpLBsbVuLlnngG4WzpT";
const ROPSTEN_PRIVATE_KEY = "9dbae4f7311d4e5244edb02c7690a161341d4515bdef1e460ef65e97c7bc08b9";
//const TokenAddrs = "0x5FbDB2315678afecb367f032d93F642f64180aa3"
module.exports = {
  solidity: {
    compilers: [    //可指定多个sol版本
          {version: "0.4.18"},
          {version: "0.5.16"},
          {version: "0.6.12"},
          {version: "0.6.6"},
          {version: "0.8.4"}
      ]
  },
  networks: {
    dev: {
      url: "http://127.0.0.1:8545",
      chainId: 31337
    },
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [`0x${ROPSTEN_PRIVATE_KEY}`],
      chainId:5
    }
  }
};
