Function Invoke-PSTenableTokenCheck {
    <#
    .SYNOPSIS
        Function that returns whether the session token has expired.
    .DESCRIPTION
        Function that returns whether the session token has expired.
    .EXAMPLE
        PS C:\> $TokenExpiry = Invoke-PStenableTokenCheck
        PS C:\> if ($TokenExpiry -eq $True) {Invoke-PSTenableTokenRenewal} else {continue}
    .INPUTS
        None
    .OUTPUTS
        $True or $False based on whether token is expired.
    .NOTES
        This a private function dedicated to checking if a token is expired.
    #>
    [CmdletBinding()]
    param (

    )

    # Credentials
    $APICredential = @{
        username       = (Get-PSFConfigValue -FullName 'PSTenable.Credential').UserName
        password       = (Get-PSFConfigValue -FullName 'PSTenable.Credential').GetNetworkCredential().Password
        releaseSession = "FALSE"
    }

    $SessionSplat = @{
        URI             = "$(Get-PSFConfigValue -FullName 'PSTenable.Server')/token"
        SessionVariable = "SCSession"
        Method          = "Post"
        ContentType     = "application/json"
        Body            = (ConvertTo-Json $APICredential)
        ErrorAction     = "Stop"
    }

    $Session = Invoke-RestMethod @SessionSplat

    if ($Session.response.releaseSession -eq $true) {
        Write-Output $true
    } else {
        Write-Output $false
    }
}

