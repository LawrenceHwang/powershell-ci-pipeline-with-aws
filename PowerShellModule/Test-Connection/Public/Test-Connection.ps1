Function Test-Connection {
  <#
  .SYNOPSIS
  Test-Connection for PowerShell Core 6

  .DESCRIPTION
  The PowerShell Core 6 does not ship with Test-Connection. This function attempts to bridge the gap.
  The function returns True when ping is successful and False when ping fails.

  .PARAMETER ComputerName
  The name of the computer to be pinged.

  .EXAMPLE
  PS C:\Program Files\PowerShell\6.0.0> Test-Connection -ComputerName google.com
  True

  .EXAMPLE
  PS C:\Program Files\PowerShell\6.0.0> Test-Connection -ComputerName thisdoesnot.exist
  False

  #>
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$ComputerName
  )

  Begin {
  }
  Process {
    Write-Verbose -Message "Pinging: $ComputerName"
    try {
      $PingResult = [System.Net.NetworkInformation.Ping]::new().Send($ComputerName)
      if ($PingResult.Status -eq 'Success') {
        Write-Verbose 'Ping success'
        $true
      }
      else {
        Write-Verbose 'Ping not success'
        $false
      }
    }
    catch {
      Write-Verbose 'Error while pinging.'
      $false
    }
  }
  End {
  }
}