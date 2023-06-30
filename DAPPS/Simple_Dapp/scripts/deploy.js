const hre = require("hardhat");

async function main() {
  // const greeter = await hre.ethers.deployContract("Greeter", ["Hello, world"]);
  const Greeter = await hre.ethers.getContractFactory("Greeter");
  const greeter = await Greeter.deploy("Hello, Hardhat!");

  await greeter.waitForDeployment();

  console.log(`Greeter deployed to ${greeter.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});