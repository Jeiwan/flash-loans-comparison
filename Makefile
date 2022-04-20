.PHONY: test

test:
	forge test --fork-url $$NODE_URL --gas-report --optimize --optimize-runs 10 -vvv