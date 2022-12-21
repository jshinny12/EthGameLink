async function main() {
  const contract_race = await ethers.getContractFactory("Race");
  const contract_results = await ethers.getContractFactory("MonacoResults");

  // Start deployment, returning a promise that resolves to a contract object
  const deployedContract_race = await contract_race.deploy();
  await deployedContract_race.deployed();
  console.log(
    "Race contract deployed to address:",
    deployedContract_race.address
  );

  const deployedContract_results = await contract_results.deploy();
  await deployedContract_results.deployed();
  console.log(
    "Results contract deployed to address:",
    deployedContract_results.address
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
