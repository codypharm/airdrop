``

# Merkle Airdrop Protocol

This project delves into the concept of Merkle airdrops, developing a system that enables users to claim airdrops without incurring gas fees. It allows protocol owners to distribute tokens seamlessly, covering the gas costs on behalf of the users. The project also integrates zkSync, providing compatibility with both standard EVM chains and the zkSync network, enhancing usability and efficiency.

## Table of Contents

- [Merkle Airdrop Extravaganza](#merkle-airdrop-protocol)
- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Quickstart](#quickstart)
- [Usage](#usage)
  - [Pre-deploy: Generate Merkle Proofs](#pre-deploy-generate-merkle-proofs)
  - [Deploy](#deploy)
    - [Deploy to Anvil](#deploy-to-anvil)
    - [Deploy to a zkSync Local Node](#deploy-to-a-zksync-local-node)
    - [Deploy to zkSync Sepolia](#deploy-to-zksync-sepolia)
  - [Interacting - zkSync Local Network](#interacting---zksync-local-network)
  - [Interacting - Local Anvil Network](#interacting---local-anvil-network)
- [Testing](#testing)
  - [Test Coverage](#test-coverage)
  - [Estimate Gas](#estimate-gas)
  - [Formatting](#formatting)
- [Thank You!](#thank-you)

## Getting Started

### Requirements

- **Git**  
  You'll know you've set it up correctly if you can run `git --version` and see a response like `git version x.x.x`.

- **Foundry**  
  You'll know it's correctly installed if you can run `forge --version` and see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`.

_To get started, we are assuming you're working with vanilla Foundry and not Foundry-zkSync._

### Quickstart

1. Clone the repository:
   ```bash
   git clone https://github.com/ciara/merkle-airdrop
   cd merkle-airdrop
   ```
2. Install dependencies and build the project:
   ```bash
   make # or forge install && forge build if you don't have make
   ```

## Usage

### Pre-deploy: Generate Merkle Proofs

To generate Merkle proofs for an array of addresses to airdrop funds to, follow these steps. If you'd like to work with the default addresses and proofs already created in this repo, skip to [Deploy](#deploy).

1. Update the array of addresses in `GenerateInput.s.sol`.
2. Generate the input file, Merkle root, and proofs:
   - Using `make`:
     ```bash
     make merkle
     ```
   - Or using the commands directly:
     ```bash
     forge script script/GenerateInput.s.sol:GenerateInput && forge script script/MakeMerkle.s.sol:MakeMerkle
     ```
3. Retrieve the root from `script/target/output.json` and:
   - Paste it in the `Makefile` as `ROOT` (for zkSync deployments).
   - Update `s_merkleRoot` in `DeployMerkleAirdrop.s.sol` for Ethereum/Anvil deployments.

### Deploy

#### Deploy to Anvil

1. Optional: Ensure you're on vanilla Foundry:
   ```bash
   foundryup
   ```
2. Run a local Anvil node:
   ```bash
   make anvil
   ```
3. In a second terminal, deploy the contracts:
   ```bash
   make deploy
   ```

#### Deploy to a zkSync Local Node

##### zkSync Prerequisites

- **Foundry-zkSync**  
  Verify it's installed by running:

  ```bash
  forge --version
  ```

  and check for a response like `forge 0.0.2 (816e00b 2023-03-16T00:05:26.396218Z)`.

- **npx & npm**  
  Verify by running:

  ```bash
  npm --version
  npx --version
  ```

  and check for responses like `npm 7.24.0` and `npx 8.1.0`.

- **Docker**  
  Verify Docker is running:
  ```bash
  docker --version
  docker --info
  ```

##### Setup Local zkSync Node

1. Configure the zkSync node:
   ```bash
   npx zksync-cli dev config
   ```
   - Select: "In memory node".
   - Do not select any additional modules.
2. Start the zkSync node:

   ```bash
   npx zksync-cli dev start
   ```

   You should see an output like:

   ```
   In memory node started v0.1.0-alpha.22:
    - zkSync Node (L2):
     - Chain ID: 260
     - RPC URL: http://127.0.0.1:8011
     - Rich accounts: https://era.zksync.io/docs/tools/testing/era-test-node.html#use-pre-configured-rich-wallets
   ```

3. To close the zkSync node in the future, run:
   ```bash
   docker ps
   docker kill ${CONTAINER_ID}
   ```

##### Deploy to a Local zkSync Network

1. Optional: Ensure you're on Foundry-zkSync:
   ```bash
   foundryup-zksync
   ```
2. Deploy:
   ```bash
   make deploy-zk
   ```

#### Deploy to zkSync Sepolia

1. Set up your environment:
   - Ensure `ZKSYNC_SEPOLIA_RPC_URL` is set in your `.env` file.
   - Ensure an account named `default` is set up for `cast`.
2. Deploy:
   ```bash
   foundryup-zksync
   make deploy-zk-sepolia
   ```

### Interacting - zkSync Local Network

The following steps allow the second default Anvil address (`0x70997970C51812dc3A010C7d01b50e0d17dc79C8`) to call `claim` and pay for the gas on behalf of the first default Anvil address (`0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266`), which will receive the airdrop.

1. Setup the zkSync node and deploy contracts:
   ```bash
   foundryup-zksync
   chmod +x interactZk.sh && ./interactZk.sh
   ```

### Interacting - Local Anvil Network

1. Setup Anvil and deploy contracts:
   ```bash
   foundryup
   make anvil
   make deploy
   ```
2. Copy the BagelToken and Airdrop contract addresses, and paste them into the `AIRDROP_ADDRESS` and `TOKEN_ADDRESS` variables in the Makefile.

3. Sign your airdrop claim:

   ```bash
   make sign
   ```

   - Retrieve the signature bytes from the terminal and add them to `Interact.s.sol` (remove the `0x` prefix).

4. Claim your airdrop:

   ```bash
   make claim
   ```

5. Check the claim amount:
   ```bash
   make balance
   ```

## Testing

1. Run the tests:

   ```bash
   foundryup
   forge test
   ```

2. For zkSync:
   ```bash
   make zktest
   ```

### Test Coverage

To check test coverage:

```bash
forge coverage
```

### Estimate Gas

To estimate gas costs:

```bash
forge snapshot
```

### Formatting

To format the code:

```bash
forge fmt
```

## Thank You!
