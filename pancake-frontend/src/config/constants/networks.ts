import { ChainId } from 'local-pancakeswap-libs/sdk'

const NETWORK_URLS: { [chainId in ChainId]: string } = {
  [ChainId.MAINNET]: 'https://bsc-dataseed1.defibit.io',
  [ChainId.TESTNET]: 'http://127.0.0.1:8545',
}

export default NETWORK_URLS
