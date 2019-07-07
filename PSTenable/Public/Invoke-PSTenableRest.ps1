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
        [hashtable]
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
