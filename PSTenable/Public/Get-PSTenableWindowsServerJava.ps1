function Get-PSTenableWindowsServerJava {
        <#
    .SYNOPSIS
        Retrieves all devices that are have an old version of Java, with a high or critical rating.
    .DESCRIPTION
        This function provides a way to retrieves all devices that are have an old version of Java, with a high or critical rating.
    .EXAMPLE
        PS C:\> Get-PSTenableWindowsServerJava
        This retrieves Java vulnerabilities that are high or critical for Windows hosts.
    .INPUTS
        None
    .OUTPUTS
        None
    .NOTES
        Helpful for retrieving all instances of Java running in your environment that is insecure.
    #>
    [CmdletBinding()]
    param (

    )

    process {
        $query = @{
            "query"      = @{
                "name"          = ""
                "description"   = ""
                "context"       = ""
                "status"        = -1
                "createdTime"   = 0
                "modifiedtime"  = 0
                "sortDir"       = "desc"
                "tool"          = "listvuln"
                "sourceType"    = "cumulative"
                "groups"        = "[]"
                "type"          = "vuln"
                "startOffset"   = 0
                "endOffset"     = 5000
                "sortField"     = "severity"
                "filters"       = @(
                    @{
                        "id"           = "family"
                        "filterName"   = "family"
                        "operator"     = "="
                        "Type"         = "vuln"
                        "isPredefined" = $true
                        "value"        = @(
                            @{
                                "id" = "20"
                            }
                        )
                    },
                    @{
                        "id"           = "pluginName"
                        "filterName"   = "pluginName"
                        "operator"     = "="
                        "type"         = "vuln"
                        "isPredefined" = $true
                        "value"        = "Oracle Java SE"
                    },
                    @{
                        "id"           = "severity"
                        "filterName"   = "severity"
                        "operator"     = "="
                        "type"         = "vuln"
                        "isPredefined" = $true
                        "value"        = "3,4"
                    })
                "sortColumn"    = "severity"
                "sortDirection" = "desc"
                "vulnTool"      = "listvuln"
            }
            "sourceType" = "cumulative"
            "sortField"  = "severity"
            "sortDir"    = "desc"
            "type"       = "vuln"
            "columns"    = "[]"
        }
        $Splat = @{
            Method   = "Post"
            Body     = $(ConvertTo-Json $query -depth 50)
            Endpoint = "/analysis"
        }
        $Results = Invoke-TenableRest @Splat
        if ($Results.response.releasesession -eq $true) {
            Invoke-TenableTokenRenewal
            $Splat = @{
                Method   = "Post"
                Body     = $(ConvertTo-Json $query -depth 5)
                Endpoint = "/analysis"
            }
            (Invoke-TenableRest @Splat).response.results
        } else {
            (Invoke-TenableRest @Splat).response.results
        }
    }
}
