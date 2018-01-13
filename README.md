# powershell-ci-pipeline-with-aws
A serverless continuous integration pipeline for PowerShell module leveraging AWS services. Bringing PowerShell's psake module and the AWS CodeCommit, CodeBuild and CodePipeline together, it allows easier development without installing and maintaining dedicated CI products.

## Components

### PowerShell

- PSake module

### Code Repository

 - Github

### AWS Services

- CloudFormation
- CodeBuild
- CodePipeline

### Other thoughts

It is possible to leverage AWS CodeCommit instead of Github. I have had it working. However, the AWS CodeCommit isn't too friendly with Git on Windows yet. Specifically that one has to make extra configurations for enabling the authentication. Once configured, the experience was fine.

## Reference and Thank You.

While experimenting with the concept, following references helped me greatly. =)

[Building a Simple Release Pipeline in PowerShell Using psake, Pester, and PSDeploy](https://devblackops.io/building-a-simple-release-pipeline-in-powershell-using-psake-pester-and-psdeploy/)

[A PowerShell Module Release Pipeline](http://ramblingcookiemonster.github.io/PSDeploy-Inception/)

[Whitepaper - The Release Pipeline Model](https://docs.microsoft.com/en-us/powershell/dsc/whitepapers)