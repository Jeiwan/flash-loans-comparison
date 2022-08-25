.PHONY: test

test:
	forge test --fork-url $$ETH_RPC_URL --gas-report --optimize --optimizer-runs 10 -vvv