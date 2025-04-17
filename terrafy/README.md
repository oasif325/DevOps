Terrafy – Azure Infrastructure Automation with Terraform & Jenkins
Terrafy is an infrastructure-as-code project automating provisioning and de-provisioning of Azure resources for dev, uat, and prod environments using:

Terraform for infrastructure management

Jenkins for CI/CD orchestration

GitHub Webhooks for automation of pipeline triggers

Azure Service Principal authentication

What's New
✅ Multi-Environment Support
Resources are dynamically named and created based on the selected environment (dev, uat, prod).

✅ Parameter-Driven CI/CD Pipeline
Jenkins pipeline accepts dynamic environment, region, SQL credentials, etc., as input parameters.

✅ Safe & Controlled Deployments
Manual approval required prior to applying or deleting resources.

✅ Selective Triggers through GitHub
Triggering of the pipeline only upon modification of main.tf, all thanks to webhook + git diff filtering.

✅ Secure Secrets Handling
Azure credentials and SQL passwords passed securely through Jenkins Credentials and password params.

Infrastructure Deployed
At run time, Terrafy deploys:

Resource Group

Virtual Network & Subnet

Network Security Group with SSH rule

Azure SQL Server & Database

Azure Storage Account

Azure Key Vault

Azure Service Bus Namespace

(Optional) Azure Function App

Technologies Used
Terraform	IaC to define and deploy Azure infra

Jenkins	CI/CD pipeline run

GitHub	Version control and webhook triggers

Azure CLI	SP creation and manual test

⚙️ How It Works?
Push change to main.tf in terrafy/ → GitHub webhook triggers Jenkins

Jenkins pipeline:

Verifies main.tf was updated

Initializes and verifies Terraform

Runs plan or destroy based on user input

Requests manual approval prior to running

Azure infra is rolled out/unrolled accordingly

Security
Makes use of Azure Service Principal stored securely in Jenkins Credentials.

No hard-coded secrets.

SQL Admin password is hidden in logs using password parameter.

Role-based access limited to scoped subscription or resource groups.

