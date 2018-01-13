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