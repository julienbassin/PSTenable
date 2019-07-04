#Requires -Modules PSFramework
function Get-PSTenablePluginFamilyWindows {
    [CmdletBinding()]
    param (
        [parameter(Position = 0)]
        [PSCredential]
        $Credential = (Get-PSFConfigValue -FullName 'PSTenable.Credential')
    )

    begin {

        # Credentials
        $APICredential = @{
            username       = $Credential.UserName
            password       = $Credential.GetNetworkCredential().Password
            releaseSession = "FALSE"
        }

        $SessionSplat = @{
            URI             = "$(Get-PSFConfigValue -FullName 'PSTenable.Server')/token"
            SessionVariable = "SCSession"
            Method          = "Post"
            ContentType     = "application/json"
            Body            = (ConvertTo-Json $APICredential)
        }

        try {
            $Session = Invoke-RestMethod @SessionSplat
        }
        catch {
            Stop-PSFFunction -Message "Username or Password is incorect." -ErrorRecord $_
            return
        }

        ## Token
        $token = $Session.response.token
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

            $body = ConvertTo-Json ($query) -depth 5

            $splat = @{
                URI        = "$(Get-PSFConfigValue -FullName 'PSTenable.Server')/analysis"
                Method     = "POST"
                Headers    = @{"X-SecurityCenter" = "$Token"}
                WebSession = $SCSession
                Body       = $body
            }

            $Output = Invoke-RestMethod @splat

        }
    }

    end {
        $output.response.results
    }
}
