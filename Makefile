
ifdef CI
	ECR_REQUIRED?=
else
	ECR_REQUIRED?=ecrLogin
endif

export ECR_ACCOUNT?=$(AWS_ACCOUNT_ID)
export AWS_DEFAULT_REGION?=ap-southeast-1
export CONTAINER_PORT?=8080
export APP_NAME=node

BUILD_VERSION?=latest
export IMAGE_NAME=$(ECR_ACCOUNT).dkr.ecr.$(AWS_DEFAULT_REGION).amazonaws.com/$(APP_NAME):$(BUILD_VERSION)

# Check for specific environment variables
env-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

.env:
	@echo "make .env"
	cp .env.template .env
	echo >> .env

ecrLogin: .env
	@echo "make ecrLogin"
	docker-compose pull aws
	$(shell docker-compose run --rm aws "aws ecr get-login --no-include-email --registry-ids $(ECR_ACCOUNT) --region $(AWS_DEFAULT_REGION)" | tail -n 1)

dockerBuild: .env
	@echo "make dockerBuild"
	docker build --no-cache -t $(IMAGE_NAME) .
.PHONY: dockerBuild

dockerPush: $(ECR_REQUIRED)
	echo "make dockerPush"
	docker push $(IMAGE_NAME)
.PHONY: dockerPush

deploy: .env
	@echo "make deploy"
	docker-compose pull deploy
	docker-compose run --rm deploy ./deploy.sh
.PHONY: deploy

install: .env
	docker-compose run --rm develop npm install

develop: .env
	docker-compose run -p 8080:8080 --rm develop npm start
.PHONY: develop

test: .env
	docker-compose run --rm develop npm test
.PHONY: test

start: .env
	docker run --name $(APP_NAME) -d --env-file .env -p $(CONTAINER_PORT):$(CONTAINER_PORT) $(IMAGE_NAME)
	docker logs $(APP_NAME) -f

stop:
	docker rm --force $(APP_NAME)

shell:
	docker run --env-file .env -it -p $(CONTAINER_PORT):$(CONTAINER_PORT) -v ${PWD}:/app:Z --entrypoint "sh" $(IMAGE_NAME)

shell-aws: .env
	docker-compose run aws /bin/bash

