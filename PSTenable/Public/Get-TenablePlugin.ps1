#Requires -Modules PSFramework
function Get-TenablePlugin {
    #Requires -Modules PSFramework
    [CmdletBinding()]
    param (
        [parameter(Position = 0)]
        [PSCredential]
        $Credential = (Get-PSFConfigValue -FullName 'PSTenable.Credential'),

        [parameter(Position = 1, mandatory = $true)]
        [string]
        $ID
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

    end {
        $output.response.results
    }
}
