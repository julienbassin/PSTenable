#Requires -Modules PSFramework
function Get-TenableSeverity {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateSet(
            'Critical',
            'High',
            'Medium',
            'Low'
        )]
        [string]
        $Severity,


        [parameter(Position = 1)]
        [PSCredential]
        $Credential = (Get-PSFConfigValue -FullName 'PSTenable.Credential'),

        [parameter(Position = 2)]
        [switch]
        $Export,

        [parameter(Position = 3)]
        [switch]
        $RawData
    )

    begin {

        switch ($Severity) {
            "Critical" {$ID = "4"}
            "High" {$ID = "3"}
            "Medium" {$ID = "2"}
            "Low" {$ID = "1"}
        }

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
                    "id"           = "severity"
                    "filterName"   = "severity"
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
