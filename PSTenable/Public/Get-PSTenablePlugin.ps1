#Requires -Modules PSFramework
function Get-PSTenablePlugin {
    #Requires -Modules PSFramework
    [CmdletBinding()]
    param (
        [parameter(Position = 0, mandatory = $true)]
        [string]
        $ID
    )

    begin {

    }

    process {

        $query = @{
            "tool"       = "vulnipdetail"
            "sortField"  = "cveID"
            "sortDir"    = "ASC"
            "type"       = "vuln"
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
                "filters"      = [array]@{
                    "id"           = "pluginID"
                    "filterName"   = "pluginID"
                    "operator"     = "="
                    "type"         = "vuln"
                    "ispredefined" = $true
                    "value"        = "$ID"
                }
                "vulntool"     = "listvuln"
                "sortField"    = "severity"
            }
        }

        $Splat = @{
            Method = "Post"
            Body = $(ConvertTo-Json $query -depth 5)
            URI = "$(Get-PSFConfigValue -FullName 'PSTenable.Server')/analysis"
        }

        $output = Invoke-PSTenableRest @Splat

    }

    end {
        $output.response.results
    }
}
