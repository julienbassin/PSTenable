function Get-PSTenablePluginFamilyWindows {
    <#
    .SYNOPSIS
        Retrieves all vulnerabilities related to the "Windows" patch family.
    .DESCRIPTION
        This function provides a way to retrieve all devices affected by the following Patch Families:
        1. Windows
        2. Windows : Microsoft Bulletins
        3. Windows : User management
    .EXAMPLE
        PS C:\> Get-PSTenablePluginFamilyWindows
        Retrieves all vulnerabilities related to the windows patch families.
    .INPUTS
        None
    .OUTPUTS
        None
    .NOTES
        None
    #>
    [CmdletBinding()]
    param (
    )

    begin {

        $WindowsPlugins = @(
            '20',
            '10',
            '29'
        )

    }

    process {

        $Output = Foreach ($plugin in $WindowsPlugins) {

            $query = @{
                "tool"       = "vulnipdetail"
                "sortField"  = "cveID"
                "sortDir"    = "ASC"
                "type"       = "vuln"
                "vulntool"   = "listvuln"
                "sourceType" = "cumulative"
                "query"      = @{
                    "name"         = ""
                    "description"  = ""
                    "context"      = ""
                    "status"       = "-1"
                    "createdTime"  = 0
                    "modifiedtime" = 0
                    "sourceType"   = "cumulative"
                    "sortDir"      = "desc"
                    "tool"         = "listvuln"
                    "groups"       = "[]"
                    "type"         = "vuln"
                    "startOffset"  = 0
                    "endOffset"    = 5000
                    "ispredefined" = $true
                    "filters"      = [array]@{
                        "id"           = "familyID"
                        "filterName"   = "familyID"
                        "operator"     = "="
                        "type"         = "vuln"
                        "ispredefined" = $true
                        "value"        = "$plugin"
                    }
                    "sortField"    = "severity"
                }
            }

            $Splat = @{
                Method   = "Post"
                Body     = $(ConvertTo-Json $query -depth 5)
                Endpoint = "/analysis"
            }

            $a = Invoke-PSTenableRest @Splat

            if ($a.response.releasesession -eq $true) {

                Invoke-PSTenableTokenRenewal

                $Splat = @{
                    Method   = "Post"
                    Body     = $(ConvertTo-Json $query -depth 5)
                    Endpoint = "/analysis"
                }

                Invoke-PSTenableRest @Splat
            }
            else {
                $a
            }

        }
    }

    end {
        $output.response.results
    }
}
