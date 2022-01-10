import tokens from './tokens'
import { SerializedFarmConfig } from './types'
import PancakePair from '../deployments/31337/PancakePair.json'
import BNB_BUSD_PAIRADDRESS from '../deployments/31337/BNB_BUSD_PairAddress.json'

const priceHelperLps: SerializedFarmConfig[] = [
  /**
   * These LPs are just used to help with price calculation for MasterChef LPs (farms.ts).
   * This list is added to the MasterChefLps and passed to fetchFarm. The calls to get contract information about the token/quoteToken in the LP are still made.
   * The absence of a PID means the masterchef contract calls are skipped for this farm.
   * Prices are then fetched for all farms (masterchef + priceHelperLps).
   * Before storing to redux, farms without a PID are filtered out.
   */
  // {
  //   pid: null,
  //   lpSymbol: 'BNB-BUSD LP',
  //   lpAddresses: {
  //     31337: PancakePair.address,
  //     56: '0x7b3ae32eE8C532016f3E31C8941D937c59e055B9',
  //   },
  //   token: tokens.busd,
  //   quoteToken: tokens.wbnb,
  // },
  {
    pid: 1,
    lpSymbol: 'BNB-BUSD LP',
    lpAddresses: {
      31337: BNB_BUSD_PAIRADDRESS.address,
      56: '0x0eD7e52944161450477ee417DE9Cd3a859b14fD0',
    },
    token: tokens.wbnb,
    quoteToken: tokens.busd,
  }
]

export default priceHelperLps
