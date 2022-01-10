const { writeAddr,writeJson } = require("./artifact_log")
const { addTokens } = require("./generate_tokenlists")
const { writeHex } = require("./writeFile/writeFile")
const BUSDJSON = require("../../deployments/31337/BUSD")
const WBNBJSON = require("../../deployments/31337/WBNB")
const USDTJSON = require("../../deployments/31337/USDT.json")

// This is a script for deploying your contracts. You can adapt it to deploy
// yours, or create new ones.
async function main() {
    // This is just a convenience check
    if (network.name === "hardhat") {
      console.warn(
        "You are trying to deploy a contract to the Hardhat Network, which" +
          "gets automatically created and destroyed every time. Use the Hardhat" +
          " option '--network localhost'"
      );
    }
  
    // ethers is avaialble in the global scope
    const [deployer] = await ethers.getSigners();
    console.log(
      "Deploying the contracts with the account:",
      await deployer.getAddress()
    );
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
      
    // 自动更改`pancake-swap-periphery`里面的`pairFor`的`hex`值
    await writeHex()

    // get json
    const chainid = network.config.chainId;
    const PancakeFactoryAddress = require(`../../deployments/${chainid}/PancakeFactory.json`)
    const WETHAddress = require(`../../deployments/${chainid}/WETH.json`)

    const _PancakeRouter = await ethers.getContractFactory("PancakeRouter");
    const PancakeRouter = await _PancakeRouter.deploy(PancakeFactoryAddress.address, WETHAddress.address);
    await PancakeRouter.deployed();
  
    console.log("PancakeRouter address:", PancakeRouter.address);

    const _PancakeRouter01 = await ethers.getContractFactory("PancakeRouter01");
    const PancakeRouter01 = await _PancakeRouter01.deploy(PancakeFactoryAddress.address, WETHAddress.address);
    await PancakeRouter01.deployed();
  
    console.log("PancakeRouter01 address:", PancakeRouter01.address);
    
    // save address
    await writeAddr(PancakeRouter.address, "PancakeRouter")
    await writeAddr(PancakeRouter01.address, "PancakeRouter01")

    // add tokens to dafault.tokenlist.json
    await addTokens("WBNB Token", "WBNB", WBNBJSON.address, chainid, 18, "https://pancakeswap.finance/images/tokens/0xbb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c.png")
    await addTokens("BUSD Token", "BUSD", BUSDJSON.address, chainid, 18, "https://pancakeswap.finance/images/tokens/0xe9e7cea3dedca5984780bafc599bd69add087d56.png")
    await addTokens("Tether USD", "USDT", USDTJSON.address, chainid, 18, "https://pancakeswap.finance/images/tokens/0x55d398326f99059ff775485246999027b3197955.png")

    // addLiquidity
    // myAddress = await deployer.getAddress()
    // const userLiquidity = await PancakeRouter.addLiquidity(WBNBJSON.address, BUSDJSON.address, 30, 30, 40, 40, myAddress, 100)
    // const userETHLiquidity = await PancakeRouter.addLiquidityETH(WBNBJSON.address, BUSDJSON.address, 30, 30, 2, 2, myAddress, 10)
    // console.log('userLiquidity', userLiquidity)
    // console.log('userETHLiquidity', userETHLiquidity)
    // We also save the contract's artifacts and address in the frontend directory
    // saveFrontendFiles(token);
  }
  
//   function saveFrontendFiles(token) {
//     const fs = require("fs");
//     const contractsDir = __dirname + "/../frontend/src/contracts";
  
//     if (!fs.existsSync(contractsDir)) {
//       fs.mkdirSync(contractsDir);
//     }
  
//     fs.writeFileSync(
//       contractsDir + "/contract-address.json",
//       JSON.stringify({ Token: token.address }, undefined, 2)
//     );
  
//     const TokenArtifact = artifacts.readArtifactSync("Token");
  
//     fs.writeFileSync(
//       contractsDir + "/Token.json",
//       JSON.stringify(TokenArtifact, null, 2)
//     );
//   }


// 不注释掉这些方法，会导致写json为空
main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  