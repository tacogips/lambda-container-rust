import * as path from "path";

import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";

export class TacogipsContainerTestAppStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const projectRoot = path.join(__dirname, "../../../../");

    const dockerFilePath = "crates/app/cdk_container/Dockerfile";

    new cdk.aws_lambda.DockerImageFunction(
      this,
      `TacogipsContainerTestAppLambdaFunction`,
      {
        functionName: `TacogipsContainerTestAppLambdaFunction`,
        code: cdk.aws_lambda.DockerImageCode.fromImageAsset(projectRoot, {
          file: dockerFilePath,
        }),
        memorySize: 3008,
        timeout: cdk.Duration.seconds(900),
        environment: {},
      },
    );
  }
}
