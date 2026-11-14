import os
import subprocess
import json
import sys
import re


class AwsCred:
    aws_access_key: str
    aws_secret: str
    aws_session_token: str

    def __init__(self, aws_access_key: str, aws_secret: str, aws_session_token: str):
        self.aws_access_key = aws_access_key
        self.aws_secret = aws_secret
        self.aws_session_token = aws_session_token


def get_aws_profile():
    return os.getenv("AWS_PROFILE")


def get_aws_session():
    return os.getenv("AWS_SESSION")


def update_envfile(cred: AwsCred):
    env_file_path = os.getenv("ENV_FILE_PATH")
    if not env_file_path:
        print("Failed to get ENV_FILE_PATH. Did you set it?")
        exit(1)

    env_file_lines = []
    if os.path.exists(env_file_path):
        with open(env_file_path, "r") as f:
            env_file_lines = f.readlines()

    ENV_AWS_ACCESS_KEY_ID = "AWS_ACCESS_KEY_ID"
    ENV_AWS_SECRET_ACCESS_KEY = "AWS_SECRET_ACCESS_KEY"
    ENV_AWS_SESSION_TOKEN = "AWS_SESSION_TOKEN"

    access_key_re = re.compile(rf"^export\s+{re.escape(ENV_AWS_ACCESS_KEY_ID)}=")
    secret_key_re = re.compile(rf"^export\s+{re.escape(ENV_AWS_SECRET_ACCESS_KEY)}=")
    token_key_re = re.compile(rf"^export\s+{re.escape(ENV_AWS_SESSION_TOKEN)}=")

    cred_infos = {
        ENV_AWS_ACCESS_KEY_ID: (access_key_re, cred.aws_access_key, False),
        ENV_AWS_SECRET_ACCESS_KEY: (secret_key_re, cred.aws_secret, False),
        ENV_AWS_SESSION_TOKEN: (token_key_re, cred.aws_session_token, False),
    }

    new_env_file_lines = []
    for each in env_file_lines:
        replaced = False
        for env_key, (matcher, new_value, _) in cred_infos.copy().items():
            if matcher.match(each):
                new_env_file_lines.append(f"export {env_key}={new_value}\n")
                cred_infos[env_key] = (matcher, new_value, True)
                replaced = True
                break

        if not replaced:
            new_env_file_lines.append(each)

    for env_key, (matcher, new_value, exists) in cred_infos.items():
        if not exists:
            new_env_file_lines.append(f"export {env_key}={new_value}\n")

    with open(env_file_path, "w") as f:
        f.writelines(new_env_file_lines)

    return env_file_path


def get_new_aws_creds(profile: str):
    cmd = f"aws configure export-credentials --profile {profile}"
    result = subprocess.run(
        cmd,
        shell=True,
        check=True,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        raise Exception(f"Failed to run aws export ")

    cred_dict = json.loads(result.stdout)
    aws_access_key = cred_dict["AccessKeyId"]
    aws_secret = cred_dict["SecretAccessKey"]
    aws_session_token = cred_dict["SessionToken"]
    aws_cred = AwsCred(aws_access_key, aws_secret, aws_session_token)
    return aws_cred


def main():
    """
    This script append or replace following lines in your env file :

    export AWS_ACCESS_KEY_ID=...
    export AWS_SECRET_ACCESS_KEY=...
    export AWS_SESSION_TOKEN=...
    """

    aws_profile = get_aws_profile()
    if not aws_profile:
        print("Failed to get aws AWS_PROFILE. Did you set it?")
        exit(1)

    new_creds = get_new_aws_creds(aws_profile)
    if not new_creds:
        print(
            "Failed to get aws new creds. Did you login with `aws sso login --sso-session [your_aws_session_name]`?"
        )
        exit(1)

    wrote_file_path = update_envfile(new_creds)
    print(f"aws creds wrote to {wrote_file_path }")


if __name__ == "__main__":
    main()
