Function Invoke-PSTenableTokenRenewal {
    <#
    .SYNOPSIS
        Function that returns another token upon session expiration.
    .DESCRIPTION
        Function that returns another token upon session expiration.
    .EXAMPLE
        PS C:\> Invoke-PSTenableTokenRenwal
    .INPUTS
        None
    .OUTPUTS
        None
    .NOTES
        This a private function dedicated to retreiving a new token for the user.
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
            ErrorVariable   = "TenableTokenError"
        }

        try {
            $Session = Invoke-RestMethod @SessionSplat
        } catch {
            if ($tenabletokenerror -match "Could not create SSL/TLS secure channel") {
                Stop-PSFFunction -Message "TLS 1.2 is not configured in your PowerShell session. Please configure prior to continuing." -ErrorRecord $_
                return
            }
        }

        Set-PSFconfig -FullName "PSTenable.Token" -Value $Session.response.token
}

