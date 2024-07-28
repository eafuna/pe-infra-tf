# HI, welcome
This repository contains bare and simple implementation of cicd for application and infrastructure.  

> [!IMPORTANT]
> Just for clarity I have re-used some codes from my other projects as well as internet resources. Nevertheless, I intentionally did not use modules for these exercise since the purpose of this is for evaluation and not production.

## guthub secrets
> [!NOTE]
> I am facing challenges when I used the storage to store tfstate so I am using these for that until that issue is resolved
- ARM_CLIENT_ID
- ARM_CLIENT_SECRET
- ARM_SUBSCRIPTION_ID
- ARM_TENANT_ID
- AZURE_CREDENTIALS

Credentials used for ACR push
- REGISTRY_LOGIN_SERVER
- REGISTRY_PASSWORD
- REGISTRY_USERNAME

## .github/workflows
There are three (3) simple workflows:
- terraform.yaml 
    - this will trigger when directory `aks` or workflow `terraform.yaml` is modified. It will provision the infrastructure
- application.yaml
    - This will trigger when directory `application` is or the `application.yml` modified. It will build and push the docker container into the ACR. Note that two (2) tags are automatically created, the `sha` and `latest` 
- helm.yaml
    - this will trigger when directory `charts` or the `helm.yml` is modified. This will trigger helm chart deployment in the AKS

## charts/
Contains the deployment of the application to the k8s

## application/
Contains the server application including the Dockerfile

## aks/
Contains IaC for terraform on AKS


> [!CAUTION]
> My goal here is create AKS with mininal configuration for the sole purpose of evaluation.

> [!IMPORTANT]
> There are [terraform modules](https://github.com/Azure/terraform-azure-modules?tab=readme-ov-file) available in the public which can be utilized. I generally use these modules instead of creating one UNLESS a specific use-case will discourage such use. In this context, I usually fork the most stable version, and use this as a sub-module in GIT

### Notes
- Challenges are encountered with Azure, I was overthrown with Microsoft Entra ID which replaced Azure AD 
- PLOP (Principle of Least Privilege) is not applied here 