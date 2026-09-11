.PHONY: fmt validate lint test plan-json policy scan docs check

fmt:
	terraform fmt -check -recursive

validate:
	terraform init -backend=false -input=false
	terraform validate

lint:
	tflint --init
	tflint --recursive -f compact

test:
	terraform test

plan-json:
	terraform init -backend=false -input=false
	terraform plan -input=false -refresh=false -var-file=tests/policy.tfvars -out=tfplan
	terraform show -json tfplan > tfplan.json

policy: plan-json
	conftest test tfplan.json --policy policies

scan:
	checkov -d . --quiet

docs:
	terraform-docs markdown table --output-file README.md .

check: fmt validate lint test policy scan
