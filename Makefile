
ifdef CI
	ECR_REQUIRED?=
else
	ECR_REQUIRED?=ecrLogin
endif

export ECR_ACCOUNT?=$(AWS_ACCOUNT_ID)
export AWS_DEFAULT_REGION?=ap-southeast-1
export CONTAINER_PORT?=3000
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
	$(shell docker-compose run --rm aws "aws ecr get-login --no-include-email --registry-ids $(ECR_ACCOUNT) --region $(AWS_DEFAULT_REGION)")

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
	docker-compose run --rm deploy ./deploy.sh
.PHONY: deploy

install: .env
	docker-compose run --rm builder npm install

build: .env
	docker-compose run --rm builder npm run build
.PHONY: build

run: .env
	docker run -d --env-file .env -p $(CONTAINER_PORT):$(CONTAINER_PORT) $(IMAGE_NAME)

test: .env
	docker-compose run --rm builder npm test
.PHONY: test

shell:
	docker run --env-file .env -it -p 3000:3000 -v ${PWD}:/app:Z --entrypoint "sh" $(IMAGE_NAME)

shell-aws: .env
	docker run --env-file .env --env-file .env.auth --env-file .env.assume -it -p 3000:3000 -v ${PWD}:/app:Z --entrypoint "sh" dnxsolutions/aws:1.4.1

style-check: .env
	docker-compose run --rm builder npm run lint -- --fix-dry-run
.PHONY: style-check
