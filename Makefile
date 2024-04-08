
TERRAFORM_DOCKERFILE=./infra/docker/terraform/Dockerfile
TERRAFORM_IMAGE_NAME=terraform-with-aws-cli

BASE_TERRAFORM=docker run --rm \
	-v $(shell pwd)/infra/terraform/:/workspace \
	-w /workspace \
	-e AWS_REGION=${AWS_REGION} \
	-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
	-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	${TERRAFORM_IMAGE_NAME}

include .env

build-terraform:
	docker build -t ${TERRAFORM_IMAGE_NAME} -f ${TERRAFORM_DOCKERFILE} .

terraform-dev:
	docker run --rm -it \
		--entrypoint=/bin/sh \
 		-v $(shell pwd)/infra/terraform/:/workspace \
		-w /workspace \
		-e AWS_REGION=${AWS_REGION} \
		-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
		-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
		${TERRAFORM_IMAGE_NAME}


echo:
	${BASE_TERRAFORM}

init:
	${BASE_TERRAFORM} init

plan: init
	${BASE_TERRAFORM} plan

deploy: init
	${BASE_TERRAFORM} apply --auto-approve

destroy: init
	${BASE_TERRAFORM} destroy --auto-approve

ecr-login:
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/p6g1c2o3

build-image-arm64: ecr-login
	cd ./url-shortener/ && docker build --platform linux/arm64 -t arm64/url-shortener . 
	docker tag arm64/url-shortener:latest public.ecr.aws/p6g1c2o3/arm64/url-shortener:latest
	docker push public.ecr.aws/p6g1c2o3/arm64/url-shortener:latest

build-image-amd64: ecr-login
	cd ./url-shortener/ && docker build --platform linux/amd64 -t amd64-url-shortener . 
	docker tag amd64-url-shortener:latest public.ecr.aws/p6g1c2o3/amd64/url-shortener:latest
	docker push public.ecr.aws/p6g1c2o3/amd64/url-shortener:latest

# running on dev
server_tracker:
	cd tracker/server_tracker && go build -o main
	cd tracker/server_tracker && \
		DEV_SQS_TRACKER_CLICKS=${DEV_SQS_TRACKER_CLICKS} \
		AWS_REGION=${AWS_REGION} \
		AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
		AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
		./main


worker_clicks:
	cd tracker/worker_clicks && go build -o main
	cd tracker/worker_clicks && \
		DEV_SQS_TRACKER_CLICKS=${DEV_SQS_TRACKER_CLICKS} \
		AWS_REGION=${AWS_REGION} \
		AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
		AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
		./main