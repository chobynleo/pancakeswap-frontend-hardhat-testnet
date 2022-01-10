const { network } = require("hardhat");

const fs = require('fs');
const path = require('path');
const util = require('util');
const writeFile = util.promisify(fs.writeFile);

async function addTokens(name, symbol, address, chainId, decimals, logoURI){
    
    const tokensDir = path.resolve(__dirname, `../../pancake-frontend/src/config/constants/tokenLists/pancake-default.tokenlist.json`);

    if (!fs.existsSync(tokensDir)) {
        console.error()
    }
    
    const tokenlists = require('../../pancake-frontend/src/config/constants/tokenLists/pancake-default.tokenlist.json')
    const token =  {
        "name": name,
        "symbol": symbol,
        "address": address,
        "chainId": chainId,
        "decimals": decimals,
        "logoURI": logoURI
    }
    tokenlists.tokens = []
    tokenlists.tokens.push(token)
    await writeFile(tokensDir, JSON.stringify(tokenlists), (err) => {
        console.log(err)
        console.log('successfully writing:', name)
    });
}

module.exports = {
    addTokens
}
