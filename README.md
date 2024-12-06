
## deploy lambda on zip image base
```sh
cd crates/app
just deploy-musl
```

Name of the lambda function will be `TacogipsZipTestAppLambdaFunction`

## deploy lambda on container image base (the image depends on glibc)

```sh
cd crates/app
just deploy-container
```

Name of the lambda function will be `TacogipsContainerTestAppLambdaFunction`