const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  // Replace this with the contract you want to deploy
  const MyContract = await ethers.getContractFactory("greet");
  const deployed = await MyContract.deploy();
  console.log("Contract deployed to:", deployed.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});