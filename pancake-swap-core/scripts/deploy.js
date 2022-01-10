const { writeAddr,writeJson } = require("./artifact_log")
const SYRUPBARJSON = require("../../deployments/31337/SyrupBar.json")
const BUSDJSON = require("../../deployments/31337/BUSD")
const WBNBJSON = require("../../deployments/31337/WBNB")

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
     
    // deployer address as feeToSetter
    feeToSetter = deployer.getAddress()
    // Fill your address as feeToSetter in constructor -> Deploy
    const PancakeFactory = await ethers.getContractFactory("PancakeFactory");
    const Factory = await PancakeFactory.deploy(feeToSetter);
    await Factory.deployed();
  
    console.log("PancakeFactory address:", Factory.address);
    
    // save contract address
    await writeAddr(Factory.address, "PancakeFactory");
    
    // save contract address
    await writeAddr(Factory.address, "PancakeFactory");

    // save init code hash
    const init_code_pair_hash = await Factory.INIT_CODE_PAIR_HASH();
    console.log("init_code_pair_hash:", init_code_pair_hash)
    await writeJson("INIT_CODE_PAIR_HASH", init_code_pair_hash, "INIT_CODE_PAIR_HASH")
    // We also save the contract's artifacts and address in the frontend directory
    // saveFrontendFiles(token);

    // Pancakepair
    const _PancakePair = await ethers.getContractFactory("PancakePair");
    const PancakePair = await _PancakePair.deploy();
    await PancakePair.deployed();
    console.log("PancakePair address:", PancakePair.address);
    // save contract address
    await writeAddr(PancakePair.address, "PancakePair");
  
    // CakeToken
   const _CAKEToken = await ethers.getContractFactory("CakeToken");
   const CakeToken = await _CAKEToken.deploy();
   await CakeToken.deployed();
   console.log("CakeToken address:", CakeToken.address);
   // save token address
   await writeAddr(CakeToken.address, "CAKE");

    // SyrupBar
   const _SyrupBar = await ethers.getContractFactory("SyrupBar");
   const SYRUPBAR = await _SyrupBar.deploy(CakeToken.address);
   await SYRUPBAR.deployed();
   console.log("SyrupBar address:", SYRUPBAR.address);
   // save token address
   await writeAddr(SYRUPBAR.address, "SyrupBar");

    // MasterChef
    const _MasterChef = await ethers.getContractFactory("MasterChef");
    const MasterChef = await _MasterChef.deploy(CakeToken.address, SYRUPBARJSON.address, deployer.getAddress(), 100, 0);
    await MasterChef.deployed();
    console.log("MasterChef address:", MasterChef.address);
    // save token address
    await writeAddr(MasterChef.address, "MasterChef");

    // SousChef
    const _SousChef = await ethers.getContractFactory("SousChef");
    const SousChef = await _SousChef.deploy(SYRUPBAR.address, 50, 0, 10);
    await SousChef.deployed();
    console.log("SousChef address:", SousChef.address);
    // save token address
    await writeAddr(SousChef.address, "SousChef");

   // PancakeProfile
   const _PancakeProfile = await ethers.getContractFactory("PancakeProfile");
   const PancakeProfile = await _PancakeProfile.deploy(CakeToken.address, 20, 20, 20);
   await PancakeProfile.deployed();
   console.log("PancakeProfile address:", PancakeProfile.address);
   // save token address
   await writeAddr(PancakeProfile.address, "PancakeProfile");
  
   // AnniversaryAchievement
   const _AnniversaryAchievement = await ethers.getContractFactory("AnniversaryAchievement");
   const AnniversaryAchievement = await _AnniversaryAchievement.deploy(PancakeProfile.address, 20, 20, 20, 20);
   await AnniversaryAchievement.deployed();
   console.log("AnniversaryAchievement address:", AnniversaryAchievement.address);
   // save token address
   await writeAddr(AnniversaryAchievement.address, "AnniversaryAchievement");

   // ClaimBackCake
   const _ClaimBackCake = await ethers.getContractFactory("ClaimBackCake");
   const ClaimBackCake = await _ClaimBackCake.deploy(CakeToken.address, PancakeProfile.address, 20, 20);
   await ClaimBackCake.deployed();
   console.log("ClaimBackCake address:", ClaimBackCake.address);
   // save token address
   await writeAddr(ClaimBackCake.address, "ClaimBackCake");
   

    // createPair BNB-BUSD LP 
    const _BNB_BUSD_PairAddress = await Factory.createPair(WBNBJSON.address, BUSDJSON.address);
    const BNB_BUSD_PairAddress = await Factory.getPair(WBNBJSON.address, BUSDJSON.address);
    const BNB_BUSD_PairAddress2 = await Factory.getPair(BUSDJSON.address, WBNBJSON.address);
    console.log("BNB-BUSD LP addresss:", BNB_BUSD_PairAddress)
    await writeAddr(BNB_BUSD_PairAddress, "BNB_BUSD_PairAddress");

    // Add BNB-BUSD LP to MasterChef
    await MasterChef.add(100, BNB_BUSD_PairAddress, true)
    const poolLength = await MasterChef.poolLength()
    console.log("poolLength:", poolLength)
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
  