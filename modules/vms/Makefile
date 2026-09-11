.PHONY: fmt validate lint test policy scan docs check

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

policy:
	conftest test tests/fixtures/tfplan.json --policy policies
	@echo "Policy passed: all taggable managed resources have required governance tags."

scan:
	checkov -d . --quiet

docs:
	terraform-docs markdown table --output-file README.md .

check: fmt validate lint test policy scan
