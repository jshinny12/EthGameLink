# Matchbox

<p align="center">
Matchbox X FD 
</p>

### In a .env folder inititalize:

```
API_URL = "alchemy-api-url"
PRIVATE_KEY = "private key"
PUBLIC_KEY = "public key"
```

### Run the following npm commands:

```
npm install
npm install @openzeppelin/contracts
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
