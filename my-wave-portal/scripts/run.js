// every time you run a terminal command that starts with npx hardhat you are getting this "hre" ( Hardhat Runtime Environment) object built on the fly using the hardhat.config.js specified in your code! This means you will never have to actually do some sort of import into your files like:
// const hre = require("hardhat")

const colors = require("colors");

const main = async () => {

  const [owner, randomPerson] = await hre.ethers.getSigners();

  // Compile our contract and generate the necessary files we need to work with our contract under the artifacts directory
  const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');

  // Hardhat will create a local Ethereum network. Everytime we run the contract, a fresh blockchain will be created
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther('0.1'), // this means deploy the contract and fund it with 0.1ETH
  });

  // Deploy the contract to local blockchain
  await waveContract.deployed();
  console.log("Contract deployed TO:".yellow, waveContract.address);
  console.log("Deployed BY:".green, owner.address);

    //Get Contract balance
    let contractBalance = await hre.ethers.provider.getBalance(
      waveContract.address
    );
    console.log(
      'Contract balance:'.bgGreen,
      hre.ethers.utils.formatEther(contractBalance) //Check if I have 0.1Eth that was funded when deploy.
    );

  // let waveCount;
  // waveCount = await waveContract.getTotalWaves();
  // console.log("Total wave count:".bgCyan, waveCount.toNumber());

   /*
   * Let's try two waves now
   */
   const waveTxn = await waveContract.wave('This is wave #1');
   await waveTxn.wait();
 
   const waveTxn2 = await waveContract.wave('This is wave #2');
   await waveTxn2.wait();

  //Get Contract balance after 2 waves
  contractBalance = await hre.ethers.provider.getBalance(
    waveContract.address
  );
  console.log(
    'Contract balance after 2 waves:'.bgRed,
    hre.ethers.utils.formatEther(contractBalance) //Check if I have 0.1Eth that was funded when deploy.
  );


  // let waveTxn = await waveContract.wave("A message!");
  // await waveTxn.wait(); // Wait for the transaction to be mined

  // Get Contract balance calling wave
  // contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  // console.log(
  //   'Contract balance:',
  //   hre.ethers.utils.formatEther(contractBalance) //Balance will drop after wave
  // );

  // // const [_, randomPerson] = await hre.ethers.getSigners();
  // waveTxn = await waveContract.connect(randomPerson).wave('Another message!');
  // await waveTxn.wait(); // Wait for the transaction to be mined

  let allWaves = await waveContract.getAllWaves();
  console.log("all waves",allWaves.red);
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