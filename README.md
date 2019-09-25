# DNX NodeJS API Sample app

Simple NodeJS API using Docker, ECR, ECS and GitlabCI.
This project aims to demontrate all the steps involved in a fresh API project to be deployed into AWS following DNX One platform.

## Requirements

docker-compose:
```
sudo curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## Build and Deploy

## Stages:

Set the account and name of ECS cluster to deploy to:
```
export CLUSTER_NAME=apps
export AWS_ACCOUNT_ID=`aws sts get-caller-identity --output text --query 'Account'`
```

Build and push container to ECR:
```
make dockerBuild dockerPush
```

Test app:
```
make test
```

Deploy to ECS:
```
make deploy
```