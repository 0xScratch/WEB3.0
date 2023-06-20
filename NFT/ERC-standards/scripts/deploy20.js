// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const SpaceToken = await hre.ethers.getContractFactory("SpaceToken_ERC20")
  const spaceToken = await SpaceToken.deploy(100000000, 50)

  await spaceToken.deployed()

  console.log("Space Token deployed: ", spaceToken.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// Command to deploy
// npx hardhat run --network sepolia scripts/deploy.js
