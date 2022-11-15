# deploy_dev.ps1
terraform workspace new dev
terraform workspace select dev
terraform fmt
terraform init
terraform validate
terraform plan -out tfplan #generate plan for req'd infra changes
terraform apply tfplan
