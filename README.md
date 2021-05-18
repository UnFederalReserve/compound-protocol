Unfederal Reserve
=================
unFederalReserve protocol is a blockchain agnostic, decentralized peer to peer lending platform based on a fork of [Compound Finance](https://compound.finance).

unFederalReserve protocol bridges liquidity across underserved assets by providing algorithmic money markets to these underserved assets. Users can supply any supported assets and use these supplied assets as collateral to borrow any other supported assets. unFederalReserve protocol has launched on Ethereum.

Before getting started with this repo, please read the [Compound protocol](https://github.com/compound-finance/compound-protocol) repo

Installation
------------

    git clone https://github.com/UnFederalReserve/compound-protocol
    cd compound-protocol
    yarn install --lock-file # or `npm install`

Building
------
    yarn compile

Testing
-------
Jest contract tests are defined under the [tests directory](https://github.com/compound-finance/compound-protocol/tree/master/tests). To run the tests run:

    yarn test

Audits
-------
unFederalReserve Protocol considers security as our top priority; our implementation team, in collaboration with third-party auditors and experts, has worked hard to build a protocol that is secure and dependable. Both contract code and balances are openly verifiable, and security researchers will earn a bug bounty for discovering previously unknown vulnerabilities.

### Security Audits
- [Coinspect Audit](/docs/security/coinspect-April-2021.md) - April, 2021
- [Hacken Audit](/docs/security/Hacken-March-2021.md) - March, 2021

Change Logs
-----------
unFederalReserve Protocol forked from this commit [c5fcc34222693ad5f547b14ed01ce719b5f4b000](https://github.com/UnFederalReserve/compound-protocol/commit/c5fcc34222693ad5f547b14ed01ce719b5f4b000) of Compound Finance

Updates:
- Add price oracle integration with chainlink
- Add claimRewards alias
