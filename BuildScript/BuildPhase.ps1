param (
    [string]$stage,
    [string]$CodeBuildID
)

Write-Output "Current path is $PSScriptRoot"

Invoke-psake -buildFile $PSScriptRoot\psake.ps1

if (-Not $psake.build_success){
    throw "Psake build failed - $CodeBuildID"
}