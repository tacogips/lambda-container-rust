#!/usr/bin/env node
import * as cdk from "aws-cdk-lib";
import { TacogipsContainerPrivateTestAppStack } from "../lib/cdk-stack";

const app = new cdk.App();
new TacogipsContainerPrivateTestAppStack(
  app,
  "TacogipsContainerPrivateTestAppStack",
  {},
);
