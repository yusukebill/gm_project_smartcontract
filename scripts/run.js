
async function main(){
    //const [owner,randoPerson]= await ethers.getSigners();
    //here I grabbed the wallet address of contract owner and I also grabbed a random wallet address and called it `randoPerson`. 
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy({value: hre.ethers.utils.parseEther("0.1")});

    // waiting for the transaction to be mined. 
    await waveContract.deployed();
    console.log("Contract addy:", waveContract.address);


    let contractBalance = await hre.ethers.provider.getBalance(waveContract.address)
    console.log("Contract Balance:", hre.ethers.utils.formatEther(contractBalance))

    
    // let count = await waveContract.getTotalWaves()
    // console.log(count.toNumber())

    let WaveTxn = await waveContract.wave("This is wave #1")
    await WaveTxn.wait();  // wait for txn to be mined. 

    WaveTxn = await waveContract.wave("This is wave #2");
    await WaveTxn.wait(); // wait for tnx to be mined

    contractBalance = await hre.ethers.provider.getBalance(waveContract.address)
    console.log("Contract Balance", hre.ethers.utils.formatEther(contractBalance))

    //waveCount = await waveContract.getTotalWaves();
   
   
    let allWaves = await waveContract.getAllWaves()
    // console.log(allWaves)

    //waveCount = await waveContract.getTotalWaves();
}

main()
    .then(()=> process.exit(0))
    .catch((error)=> {
        console.error(error);
        process.exit(1);
    })

