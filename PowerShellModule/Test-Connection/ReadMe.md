# Test-Connection

The PowerShell Core 6 does not ship with Test-Connection. This function attempts to bridge the gap.
The function returns True when ping is successful and False when ping fails.

Examples:

``` PowerShell
PS C:\Program Files\PowerShell\6.0.0> Test-Connection -ComputerName google.com
True
```

``` PowerShell
PS C:\Program Files\PowerShell\6.0.0> Test-Connection -ComputerName thisdoesnot.exist
False
```