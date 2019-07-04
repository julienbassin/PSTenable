#Requires -Modules PSFramework
function Connect-Tenable {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, mandatory = $true)]
        [PSCredential]
        $Credential = (Get-Credential -Message "Please put in your username and password"),

        [Parameter(Position = 1,mandatory = $true)]
        [string]
        $TenableServer
    )

    begin {

    }

    process {

        Set-PSFConfig -FullName "PSTenable.Server" -Value $TenableServer
        Register-PSFConfig -FullName "PSTenable.Server"
        Set-PSFconfig -FullName "PSTenable.Credential" -Value $Credential
        Register-PSFConfig -FullName "PSTenable.Credential"
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Successfully stored credentials for $($Credential.Username)"
        Write-PSFMessage -Level Verbose -Message "Successfully stored Tenable Server $($TenableServer)"
    }
}
