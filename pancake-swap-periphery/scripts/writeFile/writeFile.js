const fs = require('fs');
const path = require('path');
const util = require('util');
const writeFile = util.promisify(fs.writeFile);
const INIT_CODE_PAIR_HASH_JSON = require("../../../deployments/31337/INIT_CODE_PAIR_HASH.json")

async function writeHex(){
    
    const hexDir = path.join(__dirname, `../../contracts/libraries/PancakeLibrary.sol`);
    const txtStartDir = path.join(__dirname, `/txt/PancakeLibraryTxTStart.txt`);
    const txtEndDir = path.join(__dirname, `/txt/PancakeLibraryTxTEnd.txt`);

    if (!fs.existsSync(hexDir)) {
        console.error()
    }

    // 用于拼接的代码字符串
    let txtStart = ''
    let txtEnd = ''
    let txtHex = ''

    txtHex = INIT_CODE_PAIR_HASH_JSON.INIT_CODE_PAIR_HASH.toString()
    txtHex = txtHex.substring(2)

    //读取文件 前段部分代码
    txtStart =fs.readFileSync(txtStartDir, 'utf-8');

    //读取文件 后段部分代码
    txtEnd = fs.readFileSync(txtEndDir, 'utf-8')

    // 拼接成一个代码文件字符串
    const codeString = txtStart.concat(txtHex ,txtEnd)

    await writeFile(hexDir, codeString, (err) => {
        console.log(err)
        console.log('successfully writing:')
    });
}

module.exports = {
    writeHex
}