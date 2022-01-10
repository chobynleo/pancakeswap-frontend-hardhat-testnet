# 以下的运行顺序不能乱
# 部署合约
cd hardhat-token
npx hardhat run scripts/deploy.js --network dev

cd ../pancake-swap-core
npx hardhat run scripts/deploy.js --network dev

cd ../pancake-swap-periphery
npx hardhat run scripts/deploy.js --network dev

# 由于前端需要读取tokenlists文件，这里拷贝一份挂载到public目录下，出于vue的设置，此处不能建立软链接
cd ../pancake-frontend
cp ./src/config/constants/tokenLists/pancake-default.tokenlist.json   ./public/

# 编译sdk，放入自定义的local-pancakeswap-libs包中
cd ../pancake-swap-sdk
npm run build
cp -r ./dist ./local-pancakeswap-libs/sdk/

# 使得pancake-frontend工程中的libs与外部的sdk建立软链接 (经测试软链接的包安装不了)
#cd ../pancake-frontend/src/libs/
#ln -s ../../../pancake-swap-sdk/local-pancakeswap-libs/ ./

# 拷贝一份sdk到pancake-frontend工程中的libs中
cp -r ./local-pancakeswap-libs ../pancake-frontend/src/libs/

# 在pancake-frontend工程中安装pancakeswap-sdk 
cd ../pancake-frontend
npm run add-files 

