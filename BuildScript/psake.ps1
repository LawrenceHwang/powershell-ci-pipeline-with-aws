task default -depends Test, Linting

FormatTaskName "********* {0} *********"

task Linting {
    $Lintingesults = Invoke-ScriptAnalyzer -Path $PSScriptRoot\..\PowerShellModule\Test-Connection\Public\Test-Connection.ps1 -Severity 'Error', 'Warning' -Recurse
    if ($Lintingesults)
    {
        $Lintingesults | Write-Output
        Write-Error -Message 'PSScriptAnalyzer found error(s).Stopping build.'
        throw
    }
}


task Test -depends Linting {
    $testResults = Invoke-Pester -Script $PSScriptRoot\..\PowerShellModule\Test-Connection\Tests\Test-Connection.tests.ps1 -PassThru
    if ($testResults.FailedCount -gt 0)
    {
        $testResults | Format-List
        Write-Error -Message 'Pester test failed. Stopping build.'
        throw
    }
}