-include env/.env
.PHONY: all test deploy

build:; cd foundry && forge build

test:; cd foundry && forge test 

install :; mv foundry/src foundry/script/ foundry/test . && rm -rf foundry && mkdir foundry && git add . && git commit -m "conflit" && cd foundry && ls -la && forge init && rm -rf src script test && cd .. && mv src script test foundry && git add . && git commit -m "conflit" && cd foundry && forge install github.com/smartcontractkit/chainlink-brownie-contracts && forge install transmissions11/solmate && forge install Cyfrin/foundry-devops --no-commit && cd ..

deploy-sepolia:
	cd foundry && forge script script/DeployRaffle.sol:DeployRaffle --rpc-url $(SEPOLIA_RPC_URL) \
	--private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv