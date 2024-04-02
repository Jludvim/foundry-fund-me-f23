# FundMe

**A simple FundMe Solidity program developed following the Solidity Course created by Patrick Collins.**

This project explores basic concepts from the Solidity language, building a contract that allows it to receive funds at the respective address, register each and every one of the funders depositing into it, and allowing the owner to withdraw the accumulated funds. It also explores and includes Chainlink datafeeds for pricing and range delimiters of funds displacement. The project closely follows the original version available in the course, with small variations related to changes and updates of conventions, and small differences occurring due to the individual exploration of the problems proposed.

__IMPORTANT: It is possible that the actual use of this program could cause many security issues, and even losses. Its sole purpose is educative__

 __Use (if ever) at your own risk and responsibility__

## Layout
The software is composed of two main files in the src folder, `FundMe.sol` and `PriceConverter.sol`
The first takes care of the transactions, and noting down of the data related to it and the contract.
The second one uses the aggregatorV3Interface to take data from Chainlink's datafeed.
It should be noted that this places limitations for the usage and deployment of the contract.
The chains in which it is expected to work are Mainnet, Sepolia, and Anvil (making an artificial deployment of the datafeed).
In the scripts there is a script that does deploy the contract `DeployFundMe.s.sol`
`Interactions.s.sol` that hosts the two contracts used to interact with the contract
and `HelperConfig.s.sol` that sets correctly the datafeed related addresses according to the current blockchain id.


## Requirements

- Solidity 0.8.18 or higher
- A terminal (or WSL terminal) to execute the related commands for both the software functioning and its setup
- A blockchain address, available in Sepolia Testnet, Ethereum Mainnet, and/or provided by Anvil
- Can theoretically be used in a code execution environment that simulates the blockchain, but some functionalities related to the datafees will be lost
- Getting tokens from a Sepolia-Testnet faucet, or keeping some in the wallet
- An RPC-URL (During the course, an Alchemy.com account was used, this might or might not be an available and fine option at the time of reading this)

## Installation

1. Download the repo using your terminal
2. Navigate to the folder where the files are found (`/foundry-fund-me-f23/`) in it

## Instructions
### Deploy the contract
This step can vary depending on the Solidity modules used. In forge, it would be:

`
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url argument --private-key argument --broadcast --verify argument
`

Do not write your private key as plain text.
Respectively, the placed arguments should be the RPC-URL for the network in which it will be deployed, a private key, and optionally an Etherscan API Key for verification in Sepolia and Mainnet networks.
Using a safe way to input the private-key is advised, and the actual usage of the program as it is uploaded with actual money is discouraged for the risks that it does imply, and done at your own risk. This upload and instructions would deem itself free of responsibility for any undue use of this material, intended for learning purposes.


The main functions employed for the use of the software are `FundFundMe` and `WithdrawFundMe`.

### FundFundMe

A script that funds the last deployed contract address with a previously set value of 0.01 ether. It returns a console log stating that the operation went through successfully.
`
forge script script/Interactions.s.sol:FundFundMe --rpc-url (argument) --private-key (argument) 
--broadcast --verify -vvvv
`


```
 contract FundFundMe is Script{
    uint256 constant SEND_VALUE=0.01 ether;
    function fundFundMe(address mostRecentlyDeployed) public{
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }
    function run() external{
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(mostRecentlyDeployed);
    }
}
```

WithdrawFundMe:
A script that allows the owner of the contract to extract the accumulated funds.

`
forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url (argument) --private-key (argument) --broadcast --verify (argument) -vvvv
`


```
contract WithdrawFundMe is Script{

    function withdrawFundMe(address mostRecentlyDeployed) public{
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
    }
}

```

## Contributing

We welcome contributions. To contribute:

1. **Fork the Project**: Fork this repository to your GitHub account.
2. **Create Your Feature Branch**: Create a new branch for your feature or fix.
3. **Commit Your Changes**: Make your changes and commit them with a meaningful commit message.
4. **Push to the Branch**: Push your changes to your branch.
5. **Open a Pull Request**: Open a pull request against the main branch of this repository.

Please ensure your code adheres to the existing style to keep the project as consistent as possible.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contact

You can write at this email if you please: jeremiaspini7@gmail.com


