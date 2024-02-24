
include .env

init:
	docker run \
	-v $(shell pwd)/infra/terraform/:/workspace \
	-w /workspace \
	-v ~/.aws:/.aws/ \
	-e AWS_REGION=${AWS_REGION} \
	-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
	-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	hashicorp/terraform:1.7 \
	init

plan: init
	docker run \
	-v $(shell pwd)/infra/terraform/:/workspace \
	-w /workspace \
	-v ~/.aws:/.aws/ \
	-e AWS_REGION=${AWS_REGION} \
	-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
	-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	hashicorp/terraform:1.7 \
	plan

deploy: plan
	docker run \
	-v $(shell pwd)/infra/terraform/:/workspace \
	-w /workspace \
	-v ~/.aws:/.aws/ \
	-e AWS_REGION=${AWS_REGION} \
	-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
	-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	hashicorp/terraform:1.7 \
	apply --auto-approve

destroy: plan
	docker run \
	-v $(shell pwd)/infra/terraform/:/workspace \
	-w /workspace \
	-v ~/.aws:/.aws/ \
	-e AWS_REGION=${AWS_REGION} \
	-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
	-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	hashicorp/terraform:1.7 \
	destroy --auto-approve
