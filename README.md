# Create three  EC2 AWS Instances terraform-3-ec2

# Initiaze my terraform resources and create tfstate

$ terraform init  -backend-config="address=${ADDRESS}" -backend-config="lock_address=${ADDRESS}/lock" -backend-config="unlock_address=${ADDRESS}/lock" -backend-config="username=ngatcheu siewe Fabrice" -backend-config="password=$GITLAB_ACCESS_TOKEN" -backend-config="lock_method=POST" -backend-config="unlock_method=DELETE" -backend-config="retry_wait_min=5"


# update  tfstate file

$ terraform init -reconfigure -backend-config="address=${ADDRESS}" -backend-config="lock_address=${ADDRESS}/lock" -backend-config="unlock_address=${ADDRESS}/lock" -backend-config="username=ngatcheu siewe Fabrice" -backend-config="password=$GITLAB_ACCESS_TOKEN" -backend-config="lock_method=POST" -backend-config="unlock_method=DELETE" -backend-config="retry_wait_min=5"







