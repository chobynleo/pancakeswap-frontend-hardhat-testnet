# A hardhat testnet environment base on pancake-frontend  

## Node Environment  
(recommend)    
`nvm use 12`    

## Install
`sh install.sh`  

## Serve  
`sh serve.sh` 

## Deploy 
`sh deploy.sh`  

## Start
`sh start.sh`  

## Example
![Image text](https://raw.githubusercontent.com/chobynleo/Img/main/pancake-swap-frontend-hardhat-testnet/WechatIMG30.png)
![Image text](https://raw.githubusercontent.com/chobynleo/Img/main/pancake-swap-frontend-hardhat-testnet/WechatIMG31.png)
![Image text](https://raw.githubusercontent.com/chobynleo/Img/main/pancake-swap-frontend-hardhat-testnet/WechatIMG32.png)

## Configuration
If you want to try out the process of configuring Pancake-frontend for yourself and build your own testnet environment, 
the following will show you which files need to be modified:  

### Preparing source    
- Clone`pancake-swap-core`
```  
git clone git@github.com:pancakeswap/pancake-swap-core.git  
yarn install  
yarn compile  
```

- Clone`pancake-swap-periphery`  
```
git clone git@github.com:pancakeswap/pancake-swap-periphery.git  
yarn install  
yarn compile  
```

- Clone`pancake-frontend`  
```
git clone git@github.com:pancakeswap/pancake-frontend.git  
yarn install  
```

tip: If you got a compilation error about: `import @uniswap/v2-core/contracts/interfaces/IPancakePair.sol`  
Please refer to [upchain](https://learnblockchain.cn/question/2055)  

## Setup  
- The source code for the contract address
`https://bscscan.com/address/your_address#code`  

### In the `pancake-swap-core`directory    
+ Install `hardhat`and edit `PancakeFactory.sol`;  
`npm install --save-dev hardhat`;  
`npx hardhat` （choose `Create an empty hardhat.config.js`);  
+ Deploy tab => Select `PancakeFactory` -> Fill your address as `feeToSetter` in constructor -> Deploy  
creat  
 `scripts/deploy.js` 
`npx hardhat run scripts/deploy.js --network dev`;  
Remember to save: `INIT_CODE_PAIR_HASH`;  
 
### In the `pancake-swap-periphery`directory  
+ Install `hardhat`and edit `PancakeRouter.sol` file;  
`npm install --save-dev hardhat`;  
`npx hardhat` （choose `Create an empty hardhat.config.js`);  
+ In the `PancakeLibrary.sol` to find `pairFor`function，read `INIT_CODE_PAIR_HASH` -> Copy this hash without prefix `0x`;  
+ creat  
`scripts/deploy.js`
`npx hardhat run scripts/deploy.js --network dev`
(If you got an error about:`error:max code size exceeded`，set `solidity->optimizer->runs` to 200);  

### In the `pancake-frontend`directory

+ `ethers.providers.StaticJsonRpcProvider(RPC_URL)` is in the `src/utils/providers.ts`，that parameter is in the `env.development` of `REACT_APP_NODE_PRODUCTION`;  
+ `network url` is in the `PANCAKE-FRONTEND/src/config/constants/networks.ts`;  
+ `testnet tokens`configuration is in the `src/config/constants/tokens.ts`;  
+ `tokenlist` in the `src/config/constants/tokenlists/pancake-default.tokenlist.json`(In order to facilitate local access, I copied it to `public/`, you can do the same;  
+ `PANCAKE_EXTENDED`、`PANCAKE_TOP100` is in the `src/config/constants/lists.ts`，    
+ The configuration of the wallet connection network is in the `src/utils/wallet.ts`     
+ The configuration of `FACTORY_ADDRESS` and `INIT_CODE_HASH` are in the `node_modules/@pancakeswap/sdk/dist/constants.d.ts`;  
+ `ROUTER_ADDRESS` is in the `src/config/constants/index.ts`;
+ `masterChef`、`lotteryV2`、`multiCall` all these `contract address` are in the `src/config/constants/contracts.ts`
+ The configuration of the `ABI` and `address` are in the `config/abi/`, `utils/addressHelpers`, the reference in `src/utils/contractHelpers.ts`,`src/hooks/useContract.ts`
+ The configuration of the `priceHelperLps` are in the `src/config/constants/priceHelperLps.ts`;  
+ In the `src/state/farms/hooks.ts` about `useFarmFromPid(251)`need to be modified;    
+ In the `src/config/index.ts` about `BASE_BSC_SCAN_URLS,BASE_URL,BASE_BSC_SCAN_URL`need to be modified;
+ `farm`、`pools`、`ifo`、`pricehelper`、`contracts` all these about `chainId` need to be modified， which are in the   
`src/config/constants/farm.ts`  
`src/config/constants/pools.ts`  
`src/config/constants/ifo.ts`     
`src/config/constants/pricehelper.ts`  
`src/config/constants/contract.ts`   
