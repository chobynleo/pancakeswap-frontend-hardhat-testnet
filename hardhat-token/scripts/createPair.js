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
     
    // deployer address as feeToSetter
    feeToSetter = deployer.getAddress()
    // Fill your address as feeToSetter in constructor -> Deploy
    const PancakeFactory = await ethers.getContractFactory("PancakeFactory");
    const Factory = await PancakeFactory.deploy(feeToSetter);
    await Factory.deployed();
  
    console.log("PancakeFactory address:", Factory.address);
    
    // save contract address
    await writeAddr(Factory.address, "PancakeFactory");

    // save init code hash
    const init_code_pair_hash = await Factory.INIT_CODE_PAIR_HASH();
    console.log("init_code_pair_hash:", init_code_pair_hash)
    await writeJson("INIT_CODE_PAIR_HASH", init_code_pair_hash, "INIT_CODE_PAIR_HASH")
    // We also save the contract's artifacts and address in the frontend directory
    // saveFrontendFiles(token);
  }
  
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  