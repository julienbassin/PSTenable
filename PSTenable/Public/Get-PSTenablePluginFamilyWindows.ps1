#Requires -Modules PSFramework
function Get-PSTenablePluginFamilyWindows {
    [CmdletBinding()]
    param (
    )

    begin {

    }

    process {

        $WindowsPlugins = @(
            '20',
            '10',
            '29'
        )

        $Output =  Foreach ($plugin in $WindowsPlugins) {

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
                Method = "Post"
                Body = $(ConvertTo-Json $query -depth 5)
                URI = "$(Get-PSFConfigValue -FullName 'PSTenable.Server')/analysis"
            }

            Invoke-PSTenableRest @Splat

        }
    }

    end {
        $output.response.results
    }
}
