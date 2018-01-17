# Building a Powershell CI Pipeline
PowerShell Core became GA several days ago. It's an exciting news for the PowerShell community as it is developed with the open source community and being true cross platform.There is a lot challenges ahead , however, for us PowerShell users to refresh the current script, functions, and modules to be PowerShell Core compatible. Why would someone want to do that? To me the answer is simplicity. I look forward to the day that I use PowerShell to build tooling that work (almost) everywhere. And that day has come.

When I write a PowerShell function/ module, I **try** follow the process as much as possible:

1. Create a new Git repo and in it a new branch.
1. Write down what I want the function to do in ReadMe.
1. Explore and try what currently available cmdlets/ functions can help me achieve the goal.
1. Create a Pester test file starting with a single describe block and put my goal in the description.
1. Write Pester test (success logic path, outputs, inputs, failure logic path), git commit/ push
1. Write code that pass, git commit/ push
1. Repeat the Pester test - code cycle. Refactor as progress
1. When I feel it's *-Not* messy enough. Release the module for review/ pull request.

It's easy to run those tests locally. But, how do I know it's actually going to pass when running in another environment? How do I ensure people working on the codes follow the same process? Mor importantly, how much confidence will I have for a function's integrity? 

A serverless continuous integration pipeline for PowerShell module leveraging AWS services to improve development experience.

## What should the development experience be like

Based on my personal biased view. the PowerShell module development experience I am looking for is:

1. I have a Git repository setup
1. I make changes to the codes in the repository
1. I commit and push the PowerShell codes
1. The **system** will then **test** and **build** the PowerShell codes for me
1. The **system** will stop when a stage fails
1. The **system** will send email informing me the stages and results

You might think, for PowerShell, it is possible and probably faster to run the PSake scripts and the Pester tests locally. I think the same as well. But here is the thing. This **system** allows me retaining most of my attention on the codes and the logic. I no longer need to switch my mental context to testing, verifying and building activities. (aka. other windows) Also, I can now work on the codes on my phone while I am on the bus. I use the app, Working Copy, on iphone.

## Components

By bringing PowerShell's psake module and the AWS CodeCommit, CodeBuild and CodePipeline together, it creates a fairly nice development experience without installing and maintaining dedicated servers. In addition, I will be using Simple Notification Service (SNS) to send email notifications.

### PowerShell

- [PSake](https://github.com/psake/psake)

### Code Repository

- [Github](https://github.com/)
  - You need to generate a new [Personal Access Token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) that has `public_repo  Access public repositories` access.

### AWS Services

- CloudFormation
- CodeBuild
- CodePipeline
- Simple Notification Service (SNS)
- Simple Storage Service (S3)

## Folder Structure

Please bear with me before the install section. Understand the structured of the repository is quite important if you'd like to adopt similar approach. The purpose of each file is noted below.

```
.\
|   .gitignore
|   buildspec.yml [CodeBuild build file]
|   LICENSE
|   README.md
|
+---BuildScript [Folder containing the build scripts referenced in the buildspec.yml]
|       BuildPhase.ps1 [script for the build phase in the buildspec.yml, calls psake.ps1]
|       InstallPhase.ps1 [[script for the install phase in the buildspec.yml]]
|       psake.ps1 [The psake script]
|
+---CloudFormation
|       ci-pipeline.yaml [CloudFormation template. It is placed with the repo for convenience.]
|
\---PowerShellModule [This folder contains the codes of the PowerShell module]
    \---Test-Connection
        |   ReadMe.md
        |   Test-Connection.psm1
        |
        +---Private
        +---Public
        |       Test-Connection.ps1
        |
        \---Tests
                Test-Connection.tests.ps1
```

## Usage

1. Before starting, setup an AWS account and a Github repository.
1. Clone the Github repo locally and setup the folder structure as above.
1. Next, deploy the `cic-pipeline.yaml` CFN template in the `CloudFormation` folder to the AWS account. Enter following parameters: (It should be straight forward and can refer to the parameter descriptions in the CFN for more information)
    - GitHubUserName
    - GitHubRepoName
    - GitHubBranchName
    - GitHubToken
    - NotificationEmailAddress

1. Go to the email address entered in *NotificationEmailAddress*. There will be an email from the AWS SNS topic. Click the link in there to confirm the notification subscription.

1. Start making changes to the codes. Also make sure to update the psake script pointing to the Pester and PSScriptAnalyzer tests.

1. Commit and Push. The Source-Test-Build results are sent via email. If there is an issue, use the AWS CodeBuild console for detail messages.

1. If everything goes well, the PowerShell Module will be zipped and sent to S3 bucket created by the CFN template.

### Other Thoughts and Notes

- It is possible to leverage AWS CodeCommit instead of Github. I have had it working. However, the AWS CodeCommit isn't too friendly with Git on Windows yet. Specifically that one has to make extra configurations for enabling the authentication. Once configured, the experience was fine.

- This is just a simple CI pipeline so it currently can't skip a stage or skip a build. Every push will trigger a build even if it's just a README update.

- When using CodePipeline, both sourceType, and artifactType in the CodeBuild project must be set to: CODEPIPELINE.

- SNS Topic is triggered by CloudWatch Events so make sure the SNS Topic Policy allows.

- The output artifact is stored as zip file in S3. However, the file is named randomly (like p85ntNF). I will need to find a better way, maybe using lambda, to copy the zip and rename it. Alternatively, I can just use a PowerShell script to package and push the package elsewhere during the final phase in CodeBuild.

## Reference and Thank You

While experimenting with the concept, following references helped me greatly. Thank you kindly. =)

[Building a Simple Release Pipeline in PowerShell Using psake, Pester, and PSDeploy](https://devblackops.io/building-a-simple-release-pipeline-in-powershell-using-psake-pester-and-psdeploy/)

[A PowerShell Module Release Pipeline](http://ramblingcookiemonster.github.io/PSDeploy-Inception/)

[Whitepaper - The Release Pipeline Model](https://docs.microsoft.com/en-us/powershell/dsc/whitepapers)