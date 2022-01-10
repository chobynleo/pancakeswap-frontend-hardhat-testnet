const { network } = require("hardhat");

const fs = require('fs');
const path = require('path');
const util = require('util');

const writeFile = util.promisify(fs.writeFile);

/**
 * 记录合约发布地址
 * @param {*} deployments json
 * @param {*} name 类型
 */
async function writeAddr(addr, name){
  const chainid = network.config.chainId;
  const saveDir = path.resolve(__dirname, `../../deployments/${chainid}/`);

  if (!fs.existsSync(saveDir)) {
    fs.mkdirSync(saveDir);
  }

  const deploymentPath = saveDir + `/${name}.json`; 

  const deployments = {};
  deployments["address"] = addr;

  await writeFile(deploymentPath, JSON.stringify(deployments, null, 2));
  console.log(`Exported deployments into ${deploymentPath}`);
}

async function writeJson(key, value, name){
  const chainid = network.config.chainId;
  const saveDir = path.resolve(__dirname, `../../deployments/${chainid}/`);

  if (!fs.existsSync(saveDir)) {
    fs.mkdirSync(saveDir);
  }

  const deploymentPath = saveDir + `/${name}.json`; 

  const deployments = {};
  deployments[key] = value;

  await writeFile(deploymentPath, JSON.stringify(deployments, null, 2));
  console.log(`Exported deployments into ${deploymentPath}`);
}

module.exports = {
  writeAddr,
  writeJson
}