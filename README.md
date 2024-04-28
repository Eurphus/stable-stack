<p align="left">
  <a href="https://stacks.co">
    <img alt="Stacks" src="https://i.imgur.com/eU3g0dF.jpeg" width="80" />
  </a>
</p>

# Stable Stack

Bitcoin’s first decentralized stablecoin to support 7B people with weak currencies by providing a fast medium of exchange with low fees.

## Description

Since there are more than 1.2T dollars locked into Bitcoin, and Bitcoin undoubtedly brings a new era of technology and a new era of the global financial asset, we believe it is crucial to improve the functionality of Bitcoin, so that more people can benefit from it, especially people who do not have access to stable currencies, and liberty. For example, more than 90% of the population of Argentina owns sBTC as a store of value, and they usually trade their BTC for dollars and use the dollars to buy back the Peso. Not only is this method inefficient, but it is also a waste of energy, and resources because mining BTC requires a lot of energy and the BTC gas fee is high. Therefore, we propose a possible solution that will address these problems, and improve the efficiency of BTC. That is building a stablecoin on Stacks that allows BTC to have more uses in daily life, which will also improve the popularity of this revolutionary technology. 

Our stablecoin (Stableswap) is an overcollateralized exogenous coin that is pegged to the US Dollar because the dollar is the world reserve currency. The way it works is the following: for every $1 that users want to mint in Stableswap, they must deposit $1.5 worth of sBTC in a smart contract. They then receive a stablecoin token which represents $1 and which they can use for everyday transactions, for sending money to friends, or in DeFi protocols. Our stablecoin implements core SIP-10 token functionalities like transfers, approvals, and allowances, enabling users to send and receive tokens while controlling spending permissions for others. They are charged a small dynamic rate for holding this Stableswap, in order to support the protocol. 

The overcollaterization serves as a hedge against Bitcoin’s volatility. If the price of the deposit ever drops below $1.1, then an auction will proceed for the original deposit such that the maximum bidder will  liquidate the original depositor by buying their deposit. 
If the original user is not liquidated, then at any time they can redeposit their Stableswap back into the smart contract, burning it and unlocking their deposited BTC. 


## Technical explanation

Our main goal was to create a stablecoin (AKA a fungible token) that’s pegged to the USD because the USD is the world reserve currency, and the stablecoin is backed by sBTC because we believe sBTC is innovative and revolutionary. We used Stacks.JS to build the frontend of our website and we used 

All of our contracts are written in Clarity and the frontend is based on next.js. The contracts are deployed on the mainnet using the Hiro system.

We have three main contracts: a token contract, an oracle contract, and an engine contract. 

The token contract is responsible for implementing the basic SIP-10 interface including transferring, minting, and a new burn function was added to this contract, allowing tokens to be burned by destroying them on withdrawal. 

The oracle contract is responsible for setting the price of sBTC. Right now it is a permissioned contract, so only an authorized participant can set the price of sBTC, but in the future we would like to use Pyth as a trust-minimized decentralized oracle system. 

The engine contract is where the main logic of our project lives. This contract is responsible for the lock and mint functions, and deposit and burn functions which allow users to deposit their collateral of sBTC to receive Stableswap. In addition, this contract uses the oracle to monitor the price and liquidate the holders of Stableswap if necessary and initiate an auction. 

Stacks is a layer-2 blockchain that uses Bitcoin as a base layer for security and enables decentralized apps and predictable smart contracts using the [Clarity language](https://clarity-lang.org/). Stacks enables deploying DeFi applications that comply with regulations through its unique token issuance mechanisms.
