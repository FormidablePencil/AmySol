import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-vyper";
import "hardhat-deploy";

require('dotenv').config();

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  vyper: {
    version: "0.3.10"
  },
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545/", // This is the default Hardhat network port
      accounts: ["0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"], // Add your local Hardhat accounts
    },
  },
  namedAccounts: {
    deployer: {
      default: 0, // Index of the deployer account in the Hardhat network configuration
    },
  },
};

export default config;
