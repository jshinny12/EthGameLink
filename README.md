# EthGameLink

<p align="center">
A Franklin Dao Project 
</p>

EthGameLink is a collection of solidity interfaces that represent a generalized framework for smart-contract games. Designing a common interface for these games provides a framework for developers and improves security and interoperability. The project includes an interface that matches the design standards and best practices of other popular interfaces, such as IERC20, with potential for inheriting interfaces for more specialized games, such as games with prizes. We also instantiate an existing game, 0xMonaco, that impliments the interface to demonstrate its applicability. The project is also tested using security tools such as Echidna, Mythril, Slither, as well as traditional unit tests.

### In a .env folder inititalize:

```
API_URL = "alchemy-api-url"
PRIVATE_KEY = "private key"
PUBLIC_KEY = "public key"
```

### Run the following npm commands:

```
npm install
```

### How to Run

1. Deployment:

```sh
npx hardhat --network goerli run scripts/deploy.js
```

2. Testing:

```sh
npx hardhat test
```

### Docker and Dev Container for Echidna, Mythril, Slither

1. Choose the correct FROM line in the Docker file
2. Set the correct path for OPENZEP varaible in zshrc

### Echidna

1. npm install locally
2. Open container in Docker
3. Configure your .yami file for OPENZEP variable and contract details
4. Run:

```sh
echidna-test *.sol --contract Test --config config.yaml
```

5. If you need to check your current solc version, do the following:

```sh
solc --version
```

6. In order to change the version to use, do the following:

```sh
solc-select install [VERSION]
solc-select use [VERSION]
```

7. For Mac users, Echidna is already instally in the directory
8. Run from the contracts directory:

```sh
sudo ./../echidna/echidna-test/echidna-test RaceTest.sol --contract RaceTest --config config.yaml
```
### Slither
From the contracts folder, run

```
slither Race.sol --solc-remaps @openzeppelin/=/workspaces/Matchbox/node_modules/@openzeppelin/
```

### Mythril 
From the contracts folder, run

```
myth analyze Race.sol --solc-json config.json
```
