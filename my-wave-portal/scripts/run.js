// every time you run a terminal command that starts with npx hardhat you are getting this "hre" ( Hardhat Runtime Environment) object built on the fly using the hardhat.config.js specified in your code! This means you will never have to actually do some sort of import into your files like:
// const hre = require("hardhat")

const colors = require("colors");

const main = async () => {

  const [owner, randomPerson] = await hre.ethers.getSigners();

  // Compile our contract and generate the necessary files we need to work with our contract under the artifacts directory
  const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');

  // Hardhat will create a local Ethereum network. Everytime we run the contract, a fresh blockchain will be created
  const waveContract = await waveContractFactory.deploy();

  // Deploy the contract to local blockchain
  await waveContract.deployed();
  console.log("Contract deployed to:".yellow, waveContract.address);
  console.log("Contract deployed by:".green, owner.address);

  let waveCount;
  waveCount = await waveContract.getTotalWaves();
  console.log("Total wave count:".bgCyan, waveCount.toNumber());
  
  let waveTxn = await waveContract.wave("A message!");
  await waveTxn.wait(); // Wait for the transaction to be mined

  // const [_, randomPerson] = await hre.ethers.getSigners();
  waveTxn = await waveContract.connect(randomPerson).wave('Another message!');
  await waveTxn.wait(); // Wait for the transaction to be mined

  let allWaves = await waveContract.getAllWaves();
  console.log(allWaves);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();