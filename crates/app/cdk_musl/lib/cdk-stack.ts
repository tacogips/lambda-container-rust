import * as path from "path";
import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";

export class TacogipsZipTestAppStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const projectRoot = path.join(__dirname, "../../../../");
    const assetPath = path.join(
      projectRoot,
      "target/lambda/debug/bootstrap.zip",
    );
    new cdk.aws_lambda.Function(this, `TacogipsZipTestAppLambdaFunction`, {
      functionName: `TacogipsZipTestAppLambdaFunction`,
      runtime: cdk.aws_lambda.Runtime.PROVIDED_AL2023,
      code: cdk.aws_lambda.Code.fromAsset(assetPath),
      handler: "bootstrap",
      memorySize: 3008,
      timeout: cdk.Duration.seconds(900),
      environment: {},
    });
  }
}
