function Invoke-PSTenableRest {
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

    if ($PSBoundParameters.ContainsKey('Body')) {
        $RestMethod_Params['Body'] = $Body
    }

    $RestMethod_Params = @{ }
    $RestMethod_Params['Uri'] = $(Get-PSFConfigValue -FullName 'PSTenable.Server')/$Endpoint
    $RestMethod_Params['Method'] = $Method
    $RestMethod_Params['Headers'] = @{"X-SecurityCenter" = $(Get-PSFConfigValue -FullName 'PSTenable.Token') }
    $RestMethod_Params['ContentType'] = "application/json"
    Invoke-RestMethod @RestMethod_Params

}
