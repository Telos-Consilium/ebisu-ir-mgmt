const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contract with deployer:", deployer.address);

  const TelosConsiliumProxy = await hre.ethers.getContractFactory("TelosConsiliumProxy");

  const adminAddress = "0xF3d3f4281CEa79ABA34acbf6460b9f7c5767C506";

  const contract = await TelosConsiliumProxy.deploy(adminAddress);

  await contract.waitForDeployment();

  console.log("TelosConsiliumProxy deployed at:", await contract.getAddress());
  console.log("Admin set to:", adminAddress);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});