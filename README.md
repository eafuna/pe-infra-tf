# aks
Contains IaC for terraform on AKS


> [!CAUTION]
> My goal here is create AKS with mininal configuration for the sole purpose of evaluation.

> [!IMPORTANT]
> There are [terraform modules](https://github.com/Azure/terraform-azure-modules?tab=readme-ov-file) available in the public which can be utilized. I generally use these modules instead of creating one UNLESS a specific use-case will discourage such use. In this context, I usually fork the most stable version, and use this as a sub-module in GIT

## Notes
- Challenges are encountered with Azure, I was overthrown with Microsoft Entra ID which replaced Azure AD 
- PLOP (Principle of Least Privilege) is not applied here 