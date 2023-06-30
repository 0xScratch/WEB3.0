const hre = require("hardhat");


async function main() {
  const NAME = "AI-NFT Generator"
  const SYMBOL = "GenZ"
  const COST = ethers.parseEther("1") // 1 ETH

  const NFT = await hre.ethers.getContractFactory("NFT")
  const nft = await NFT.deploy(NAME, SYMBOL, COST)
  await nft.waitForDeployment()

  console.log(`Deployed NFT Contract at: ${nft.target}`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});