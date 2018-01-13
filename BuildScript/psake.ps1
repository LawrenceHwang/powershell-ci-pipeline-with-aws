task default -depends Test, Linting

FormatTaskName "********* {0} ********* ^_^/"

task Linting {
    $Lintingesults = Invoke-ScriptAnalyzer -Path $PSScriptRoot\..\PSModule\Psjack\Public\Get-MidwayCookie.ps1 -Severity 'Error', 'Warning' -Recurse
    if ($Lintingesults)
    {
        $Lintingesults | Write-Output
        Write-Error -Message 'PSScriptAnalyzer found error(s).Stopping build.'
        throw
    }
}


task Test -depends Linting {
    $testResults = Invoke-Pester -Script $PSScriptRoot\..\PSModule\Psjack\Tests\Get-MidwayCookie.tests.ps1 -PassThru
    if ($testResults.FailedCount -gt 0)
    {
        $testResults | Format-List
        Write-Error -Message 'Pester test failed. Stopping build.'
        throw
    }
}

<#
task Build -depends Test { # module versioning..etc}

task DeploytoS3 -depends Test {

    $FileTime = (get-date).ToFileTime()

    Compress-Archive -Path $PSScriptRoot\..\PSModule -DestinationPath "$PSScriptRoot\..\result.$FileTime.zip"

    Initialize-AWSDefaults
    Write-S3Object -BucketName 'pspipedpiperpipeline' -file "$PSScriptRoot\..\result.$FileTime.zip" -Region us-east-2

    if ($testResults.FailedCount -gt 0) {
        $testResults | Format-List
        Write-Error -Message 'Pester test failed. Stopping build.'
        throw
    }
}
#>
