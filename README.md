# DNX NodeJS API Sample app

Simple NodeJS API using Docker, ECR, ECS and GitlabCI.
This project aims to demontrate all the steps involved in a fresh API project to be deployed into AWS following DNX One platform.

## Build and Deploy

## Stages:

Set the account and name of ECS cluster to deploy to:
```
export CLUSTER_NAME=apps
export AWS_ACCOUNT_ID=<<CHANGEME>>
```

Build and push container to ECR:
```
make dockerBuild dockerPush
```

Deploy to ECS:
```
make deploy
```