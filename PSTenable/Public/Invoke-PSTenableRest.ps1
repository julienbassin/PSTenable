function Invoke-PSTenableRest {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]
        $Endpoint,

        [Parameter(Mandatory = $true)]
        [string]
        $Method,

        [Parameter(Mandatory = $true)]
        $Body
    )

    $RestMethod_Params = @{ }
    $RestMethod_Params['Uri'] = $(Get-PSFConfigValue -FullName 'PSTenable.Server')
    $RestMethod_Params['Endpoint'] = $Endpoint
    $RestMethod_Params['Method'] = $Method
    $RestMethod_Params['Headers'] = @{"X-SecurityCenter" = $(Get-PSFConfigValue -FullName 'PSTenable.Token') }
    $RestMethod_Params['ContentType'] = "application/json"
    $RestMethod_Params['Body'] = $Body
    Invoke-RestMethod @RestMethod_Params

}
