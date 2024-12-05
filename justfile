node2nix:
	node2nix -o nix/node-packages.nix	-e nix/node-env.nix	-c nix/default.nix -i package.json
	nixfmt nix/*

refresh-aws-cred aws-profile="default" do-login="false" aws-session="" env-file-path="./.envrc.private":
	AWS_PROFILE={{aws-profile}} AWS_SESSION={{aws-session}} ENV_FILE_PATH={{env-file-path}} python scripts/refresh_aws_creds.py


build-container:
	docker build -f crates/app/cdk_container/Dockerfile .
