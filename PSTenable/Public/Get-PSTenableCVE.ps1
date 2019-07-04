#Requires -Modules PSFramework
function Get-PSTenableCVE {
    #Requires -Modules PSFramework
    [CmdletBinding()]
    param (
        [parameter(Position = 0)]
        [PSCredential]
        $Credential = (Get-PSFConfigValue -FullName 'PSTenable.Credential'),

        [parameter(Position = 1, mandatory = $true)]
        [string]
        $CVE
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
            "tool"       = "vulnipdetail";
            "sortField"  = "cveID";
            "sortDir"    = "ASC";
            "type"       = "vuln";
            "sourceType" = "cumulative";
            "query"      = @{
                "createdTime"  = 0;
                "sourceType"   = "cumulative";
                "sortDir"      = "desc";
                "tool"         = "vulnipdetail";
                "modifiedTime" = 0;
                "name"         = "";
                "type"         = "vuln";
                "filters"      = [array]@{
                    "operator"   = "=";
                    "value"      = $CVE;
                    "filterName" = "cveID"
                };
                "description"  = "";
                "sortField"    = "severity";
                "startOffset"  = 0;
                "context"      = "";
                "endOffset"    = 5000
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

        $results = Invoke-RestMethod @splat

        ## Get the pluginID and then call Get-TenablePlugin, and then output those results
        $output = Foreach ($Plugin in $results.response.results.pluginid) {
            Get-PSTenablePlugin -Credential $Credential -ID $Plugin
        }

    }

    end {
        $output
    }
}
