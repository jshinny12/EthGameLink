async function main() {
    const contract = await ethers.getContractFactory("contract")
  
    // Start deployment, returning a promise that resolves to a contract object
    const deployedContract = await contract.deploy()
    await deployedContract.deployed()
    console.log("Contract deployed to address:", deployedContract.address)
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })