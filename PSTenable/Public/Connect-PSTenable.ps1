function Connect-PSTenable {
    <#
    .SYNOPSIS
        Connects to the Tenable API and sets credentials, token, web session, and Tenable Server using PSFramework.
    .DESCRIPTION
        This function provides a way to set the credentials, token, web session, and
        tenable server that is used within PSTenable.
    .EXAMPLE
        PS C:\> $Cred = Get-Credential
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

    }

    process {

        Set-PSFConfig -FullName "PSTenable.Server" -Value $TenableServer
        Set-PSFconfig -FullName "PSTenable.Credential" -Value $Credential

        if ($PSBoundParameters.ContainsKey('Register')) {
            Register-PSFConfig -FullName "PSTenable.Server"
            Register-PSFConfig -FullName "PSTenable.Credential"
        }

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

        try {
            $Session = Invoke-RestMethod @SessionSplat
        } catch {
            Stop-PSFFunction -Message "Username or Password is incorect." -ErrorRecord $_
            return
        }
    }

    end {

        if ($PSBoundParameters.ContainsKey('Register')) {
            Set-PSFconfig -FullName "PSTenable.Token" -Value $Session.response.token
            Set-PSFconfig -FullName "PSTenable.WebSession" -Value $SCSession
            Register-PSFConfig -FullName "PSTenable.Token"
            Register-PSFConfig -FullName "PSTenable.WebSession"
        }

        Set-PSFconfig -FullName "PSTenable.Token" -Value $Session.response.token
        Set-PSFconfig -FullName "PSTenable.WebSession" -Value $SCSession
    }
}
