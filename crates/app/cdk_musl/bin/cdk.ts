#!/usr/bin/env node
import * as cdk from "aws-cdk-lib";
import { TacogipsTestAppStack } from "../lib/cdk-stack";

const app = new cdk.App();
new TacogipsTestAppStack(app, "TacogipsTestAppStack", {});
