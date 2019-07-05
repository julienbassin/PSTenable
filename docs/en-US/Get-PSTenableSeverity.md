---
external help file: PSTenable-help.xml
Module Name: PSTenable
online version:
schema: 2.0.0
---

# Get-PSTenableSeverity

## SYNOPSIS
Retrieves all vulnerabilities that are Critical, High, Medium, or Low in Tenable.

## SYNTAX

```
Get-PSTenableSeverity [-Severity] <String> [<CommonParameters>]
```

## DESCRIPTION
This function provides a way to retrieve all vulnerabilities in Tenable that are Critical, High,
Meidum, or Low.

## EXAMPLES

### EXAMPLE 1
```
Get-PSTenableSeverity -Severity "Critical"
```

Retrieves all criitcal vulnerabilities.

## PARAMETERS

### -Severity
{{ Fill Severity Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### None
## NOTES
None

## RELATED LINKS
