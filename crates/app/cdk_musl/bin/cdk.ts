#!/usr/bin/env node
import * as cdk from "aws-cdk-lib";
import { TacogipsZipTestAppStack } from "../lib/cdk-stack";

const app = new cdk.App();
new TacogipsZipTestAppStack(app, "TacogipsZipTestAppStack", {});
