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
  
  let waveTxn = await waveContract.wave();
  await waveTxn.wait();

  // Finally, We grab the waveCount one more time to see if it changed.
  waveCount = await waveContract.getTotalWaves();


  let wavers =[]
  //  this simulate other people hitting our wave functions
  
  waveTxn = await waveContract.connect(randomPerson).wave();
  wavers.push(randomPerson.address);
  console.log("These are my waver".blue, wavers);

  await waveTxn.wait();

  waveCount = await waveContract.getTotalWaves();
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