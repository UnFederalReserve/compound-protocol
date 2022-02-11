# Run tests in Docker


**FIRST** - run docker
```bash
docker run --rm -v `pwd`:/app -it node:13.8.0 bash
```


**SECOND** - install solc *in docker image* for compile contracts
```bash
wget https://github.com/ethereum/solidity/releases/download/v0.5.16/solc-static-linux -O /bin/solc && chmod +x /bin/solc
```


**THIRD** - install dependencies *in docker image*
```bash
cd /app
yarn install
```


**FOURTH** - compile contract *in docker image*
<br>compile contract only with v0.5.16
```bash
export SADDLE_SHELL=/bin/sh
export SADDLE_CONTRACTS="contracts/*.sol contracts/Chainlink/*.sol contracts/Governance/*.sol contracts/Lens/CompoundLens.sol tests/Contracts/*.sol"
npx saddle compile
```


**IN FIFTH** - run tests *in docker image*
```bash
yarn run test:prepare
yarn run test
# npx saddle test
```
