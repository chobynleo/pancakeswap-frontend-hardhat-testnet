cd hardhat-token
npx hardhat run scripts/deploy.js --network dev

cd ../pancake-swap-core
npx hardhat run scripts/deploy.js --network dev

cd ../pancake-swap-periphery
npx hardhat run scripts/deploy.js --network dev

cd ../pancake-frontend
cp ./src/config/constants/tokenLists/pancake-default.tokenlist.json   ./public/

cd ../pancake-swap-sdk
npm run build
cp -r ./dist ./local-pancakeswap-libs/sdk/

cp -r ./local-pancakeswap-libs ../pancake-frontend/node_modules

