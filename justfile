refresh-aws-cred aws-profile="default" do-login="false" aws-session="" env-file-path="./.envrc.private":
	AWS_PROFILE={{aws-profile}} AWS_SESSION={{aws-session}} ENV_FILE_PATH={{env-file-path}} python scripts/refresh_aws_creds.py


build-container:
	docker build -f crates/app/cdk_container/Dockerfile .
