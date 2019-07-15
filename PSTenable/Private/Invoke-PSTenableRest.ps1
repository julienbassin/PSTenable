function Invoke-PSTenableRest {
    <#
    .SYNOPSIS
        Wrapper around Invoke-RestMethod.
    .DESCRIPTION
        This function provides a way to execute Invoke-RestMethod using common parameters required by PSTenable.
    .EXAMPLE
        PS C:\> Invoke-PSTenableRest -Endpoint "/analysis" -Method "GET" -Body $Body
        Using Invoke-RestMethod, posts a GET to /analysis with $body.
    .INPUTS
        None
    .PARAMETER Endpoint
        The rest endpoint used in Invoke-RestMethod, such as /analysis.
    .PARAMETER Method
        POST, GET, DELETE, CREATE
    .PARAMETER Body
        Body of Invoke-RestMethod
    .OUTPUTS
        None
    .NOTES
        None
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]
        $Endpoint,

        [Parameter(Mandatory = $true)]
        [string]
        $Method,

        [Parameter(Mandatory = $false)]
        $Body
    )

    Begin {

        $RestMethodParams = @{
            URI         = $(Get-PSFConfigValue -FullName 'PSTenable.Server') + $Endpoint
            Method      = $Method
            Headers     = @{"X-SecurityCenter" = $(Get-PSFConfigValue -FullName 'PSTenable.Token') }
            ContentType = "application/json"
            ErrorAction = "Stop"
            WebSession  = $(Get-PSFConfigValue -FullName "PSTenable.WebSession")
        }

        if ($PSBoundParameters.ContainsKey('Body')) {
            $RestMethodParams.Add('Body', $Body)
        }
    }

    Process {
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

        Invoke-RestMethod @RestMethodParams
    }

    End {
        [Net.ServicePointManager]::SecurityProtocol = $currentVersionTls
        $ProgressPreference = $currentProgressPref
    }

}
