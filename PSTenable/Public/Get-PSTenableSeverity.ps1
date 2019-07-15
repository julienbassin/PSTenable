function Get-PSTenableSeverity {
    <#
    .SYNOPSIS
        Retrieves all vulnerabilities that are Critical, High, Medium, or Low in Tenable.
    .DESCRIPTION
        This function provides a way to retrieve all vulnerabilities in Tenable that are Critical, High,
        Meidum, or Low.
    .EXAMPLE
        PS C:\> Get-PSTenableSeverity -Severity "Critical"
        Retrieves all criitcal vulnerabilities.
    .INPUTS
        None
    .PARAMETER Severity
        Option for Critical, High, Medium or Low.
    .OUTPUTS
        None
    .NOTES
        None
    #>
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
        $Severity
    )

    begin {

        $TokenExpiry = Invoke-PSTenableTokenStatus
        if ($TokenExpiry -eq $True) {Invoke-PSTenableTokenRenewal}

        switch ($Severity) {
            "Critical" { $ID = "4" }
            "High" { $ID = "3" }
            "Medium" { $ID = "2" }
            "Low" { $ID = "1" }
        }

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

        $Splat = @{
            Method   = "Post"
            Body     = $(ConvertTo-Json $query -depth 5)
            Endpoint = "/analysis"
        }
    }

    end {
        Invoke-PSTenableRest @Splat | Select-Object -ExpandProperty Response | Select-Object -ExpandProperty Results
    }
}
