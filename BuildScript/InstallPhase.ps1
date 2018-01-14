param (
    [string]$stage,
    [string]$CodeBuildID
)

$PSVersionTable

Install-Module -Name psake -Force
Install-Module -Name pester -Force
Install-Module -Name PSScriptAnalyzer -Force
# Install-Module -Name AWSPowerShell.netcore -Force