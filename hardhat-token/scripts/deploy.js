const { writeAddr,writeJson } = require("./artifact_log")
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
      
    // WETH
    const _WETH = await ethers.getContractFactory("WETH");
    const WETH = await _WETH.deploy();
    await WETH.deployed();
    console.log("WETH address:", WETH.address);
    // save token address
    await writeAddr(WETH.address, "WETH");

    // WBNB
    const _WBNB = await ethers.getContractFactory("WBNB");
    const WBNB = await _WBNB.deploy();
    await WBNB.deployed();
    console.log("WBNB address:", WBNB.address);
    // save token address
    await writeAddr(WBNB.address, "WBNB");

    // BAKEToken
    const _BAKEToken = await ethers.getContractFactory("BakeryToken");
    const BAKEToken = await _BAKEToken.deploy();
    await BAKEToken.deployed();
    console.log("BAKEToken address:", BAKEToken.address);
    // save token address
    await writeAddr(BAKEToken.address, "BAKE");
    
    // BUSDToken
    const _BUSDToken = await ethers.getContractFactory("BEP20Token");
    const BUSDToken = await _BUSDToken.deploy();
    await BUSDToken.deployed();
    console.log("BUSDToken address:", BUSDToken.address);
    // save token address
    await writeAddr(BUSDToken.address, "BUSD");
    
    // DAIToken
    const _DAIToken = await ethers.getContractFactory("BEP20DAI");
    const DAIToken = await _DAIToken.deploy();
    await DAIToken.deployed();
    console.log("DAIToken address:", DAIToken.address);
    // save token address
    await writeAddr(DAIToken.address, "DAI");

    // ETHToken
    const _ETHToken = await ethers.getContractFactory("BEP20Ethereum");
    const ETHToken = await _ETHToken.deploy();
    await ETHToken.deployed();
    console.log("ETHToken address:", ETHToken.address);
    // save token address
    await writeAddr(ETHToken.address, "ETH");

    // USDTToken
    const _USDTToken = await ethers.getContractFactory("BEP20USDT");
    const USDTToken = await _USDTToken.deploy();
    await USDTToken.deployed();
    console.log("USDTToken address:", USDTToken.address);
    // save token address
    await writeAddr(USDTToken.address, "USDT");

    // XRPToken
    const _XRPToken = await ethers.getContractFactory("BEP20XRP");
    const XRPToken = await _XRPToken.deploy();
    await XRPToken.deployed();
    console.log("XRPToken address:", XRPToken.address);
    // save token address
    await writeAddr(XRPToken.address, "XRP");
   
    // MULTICALL
    const _Multicall = await ethers.getContractFactory("Multicall2");
    const Multicall = await _Multicall.deploy();
    await Multicall.deployed();
    console.log("Multicall address:", Multicall.address);
    // save token address
    await writeAddr(Multicall.address, "Multicall");



   
  



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
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  