node {

    stage ('checkout') {

        echo "- - - - Checkout Code - - - -"
	checkout scm
    }

    stage ('setupenv') {
    	echo " - - - - Setting up environment now - - - - "
	}

    stage ('TerraformActivity') {
    
    echo " - - - - Ready to execute Terraform now - - - - "
    sh '''
   echo "started" 
   export VAULT_ADDR='http://127.0.0.1:8200'
   export VAULT_TOKEN="s.Q3d2iMzJKGrxHgQMnS6q5b1y"
   export AWS_ACCESS_KEY_ID="`/opt/vault kv get -field="access_key_id" secret/wrtaws`"
   export AWS_SECRET_ACCESS_KEY="`/opt/vault kv get -field="secret_access_key" secret/wrtaws`"
   export AWS_DEFAULT_REGION="`/opt/vault kv get -field="default_region" secret/wrtaws`"
   
   cd tf
   echo `/opt/terraform --version`
   /opt/terraform init
    {
    while read -r line
    do
    	platform=$(echo "$line" |awk -F "," '{ print $1 }')
	version=$(echo "$line" |awk -F "," '{ print $2 }')
	package=$(echo "$line" |awk -F "," '{ print $3 }')
	allowed_port=$(echo "$line" |awk -F "," '{ print $4 }')
	db_With_TestData=$(echo "$line" |awk -F "," '{ print $6 }')
	s3_Data_Link=$(echo "$line" |awk -F "," '{ print $7 }')
	project=$(echo "$line" |awk -F "," '{ print $8 }')
	environment=$(echo "$line" |awk -F "," '{ print $9 }')
	Deployment=$(echo "$line" |awk -F "," '{ print $11 }')
	appName=$(echo "$line" |awk -F "," '{ print $12 }')
	infra=$(echo "$line" |awk -F "," '{ print $5 }')
	
	if [ "$infra" = "Y" ];then
		echo "yes" | /opt/terraform plan -var "sg_name=aws-security-group-poc" -var "port=8080"
		echo "yes" | /opt/terraform apply -var "sg_name=aws-security-group-poc" -var "port=8080"
	fi
	removeInfra=$(echo "$line" |awk -F "," '{ if ($5=="N") print $10; }')
	echo "$removeInfra"
	if [ "$removeInfra" = "Y" ]; then
		echo "yes" | /opt/terraform destroy -var "sg_name=aws-security-group-poc" -var "port=8080"
	fi
    done
    } < ./../config.csv
    echo " - - - - - - C O M P L E T E D - - - - - - - "
    
    '''
    }
}
