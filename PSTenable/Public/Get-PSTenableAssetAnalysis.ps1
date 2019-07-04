#Requires -Modules PSFramework
function Get-PSTenableAssetAnalysis {
    [CmdletBinding()]
    param (
        [String]
        [Parameter(Position = 0, Mandatory = $true)]
        [string]
        $ComputerName,


        [parameter(Position = 1)]
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
        } catch {
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
                    "id"           = "dnsName"
                    "filterName"   = "dnsName"
                    "operator"     = "="
                    "type"         = "vuln"
                    "ispredefined" = $true
                    "value"        = "$ComputerName"
                }
                "vulntool"     = "listvuln"
                "sortField"    = "severity"
            }
        }

        $body = ConvertTo-Json ($query) -depth 5

        $splat = @{
            URI        = "$(Get-PSFConfigValue -FullName 'PSTenable.Server')/analysis"
            Method     = "POST"
            WebSession = $SCSession
            Headers    = @{"X-SecurityCenter" = "$Token"}
            Body       = $body
        }

        $Output = Invoke-RestMethod @splat

    }

    end {
        $Output.response.results
    }
}
