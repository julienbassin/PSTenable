Function Invoke-PSTenableTokenRenewal {
    <#
    .SYNOPSIS
        Function that returns another token upon session expiration.
    .DESCRIPTION
        Function that returns another token upon session expiration.
    .EXAMPLE
        PS C:\> Invoke-PSTenableTokenRenewal
    .INPUTS
        None
    .OUTPUTS
        None
    .NOTES
        This a private function dedicated to retreiving a new token for the user and storing it using PSFramework.
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

    ## Enable TLS 1.2
    ## Taken from https://github.com/potatoqualitee/kbupdate/blob/master/kbupdate.psm1
    $currentProgressPref = $ProgressPreference
    $ProgressPreference = "SilentlyContinue"
    $currentVersionTls = [Net.ServicePointManager]::SecurityProtocol
    $currentSupportableTls = [Math]::Max($currentVersionTls.value__, [Net.SecurityProtocolType]::Tls.value__)
    $availableTls = [enum]::GetValues('Net.SecurityProtocolType') | Where-Object { $_ -gt $currentSupportableTls }
    $availableTls | ForEach-Object {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor $_
    }

    $Session = Invoke-RestMethod @SessionSplat

    [Net.ServicePointManager]::SecurityProtocol = $currentVersionTls
    $ProgressPreference = $currentProgressPref

    Set-PSFconfig -FullName "PSTenable.Token" -Value $Session.response.token
}
