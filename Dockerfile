
# solcjs --bin --abi --include-path node_modules/ --base-path . -o . SimpleStorage.sol
# git push --set-upstream origin container-setup

FROM node:18

WORKDIR /app

COPY . .

RUN apt-get update && apt-get install -y expect jq git && \
    yarn init -y && yarn add --dev hardhat && \
    chmod +x shell/auto-hardhat.exp && expect shell/auto-hardhat.exp && \
    yarn add --dev @nomiclabs/hardhat-ethers@npm:hardhat-deploy-ethers ethers \
    @nomiclabs/hardhat-etherscan  \ 
    @nomiclabs/hardhat-waffle chai ethereum-waffle \
    hardhat hardhat-contract-sizer hardhat-deploy hardhat-gas-reporter prettier \
    prettier-plugin-solidity solhint solidity-coverage dotenv @chainlink/contracts && \
    sh shell/apply_prettier.sh && rm -rf shell && \
    rm -rf /var/lib/apt/lists/* && apt-get clean && \
    rm contracts/Lock.sol && \
    git config --global user.name "aperisss" && \
    git config --global user.email "peris.adam@outlook.fr"
    git stash --include-untracked && git checkout main && \
    git fetch origin && git reset --hard origin/main

CMD ["bash"]