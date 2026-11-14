#!/usr/bin/env node
import * as cdk from "aws-cdk-lib";
import { TacogipsContainerTestAppStack } from "../lib/cdk-stack";

const app = new cdk.App();
new TacogipsContainerTestAppStack(app, "TacogipsContainerTestAppStack", {});
