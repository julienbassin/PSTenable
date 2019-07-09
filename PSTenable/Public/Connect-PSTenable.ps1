function Connect-PSTenable {
    <#
    .SYNOPSIS
        Connects to the Tenable API and sets credentials, token, web session, and Tenable Server using PSFramework.
    .DESCRIPTION
        This function provides a way to set the credentials, token, web session, and
        tenable server that is used within PSTenable.
    .EXAMPLE
        PS C:\> Connect-PSTenable -Credential $Cred -TenableServer "tenable.domain.com/rest" -Register
        This prompts for user credentials, and then, using Connect-PSTenable, sets the credentials,
        token, web session, and the Tenable Server using PSFramework.
    .PARAMETER Credential
        PSCredential Object
    .PARAMETER TenableServer
        Tenable Server Name, tenable.domain.com/rest
    .PARAMETER Register
        If specified, this will cache the Credential, TenableServer, Token, and Web Session.
    .INPUTS
        None
    .OUTPUTS
        None
    .NOTES
        If Connect-PSTenable is not ran with the Register switch, then Connect-PSTenable
        must be ran each time since Tenable requires a unique token for each session.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, mandatory = $true)]
        [PSCredential]
        $Credential,

        [Parameter(Position = 1, mandatory = $true)]
        [string]
        $TenableServer,

        [Parameter(Position = 2, mandatory = $false)]
        [switch]
        $Register
    )
    begin {

        if ($TenableServer -notmatch "https") {
            # Disable SSL certificate validation.
            [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
        }
    }

    process {

        # Credentials
        $APICredential = @{
            username       = $Credential.UserName
            password       = $Credential.GetNetworkCredential().Password
            releaseSession = "FALSE"
        }

        $SessionSplat = @{
            URI             = "$TenableServer/token"
            SessionVariable = "SCSession"
            Method          = "Post"
            ContentType     = "application/json"
            Body            = (ConvertTo-Json $APICredential)
            ErrorAction     = "Stop"
            ErrorVariable   = "TenableTokenError"
        }

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
    }

    end {

        Set-PSFconfig -FullName "PSTenable.WebSession" -Value $SCSession
        Set-PSFconfig -FullName "PSTenable.Token" -Value $Session.response.token
        Set-PSFConfig -FullName "PSTenable.Server" -Value $TenableServer
        Set-PSFconfig -FullName "PSTenable.Credential" -Value $Credential

        if ($PSBoundParameters.ContainsKey('Register')) {
            Register-PSFConfig -FullName "PSTenable.WebSession"
            Register-PSFConfig -FullName "PSTenable.Token"
            Register-PSFConfig -FullName "PSTenable.Server"
            Register-PSFConfig -FullName "PSTenable.Token"
        }
    }
}
