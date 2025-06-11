require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config(); // <- importa dotenv

module.exports = {
  solidity: "0.8.28",
  networks: {
    mainnet: {
      url: `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: {
      mainnet: process.env.ETHERSCAN_API_KEY
    }
  }
};
