---
external help file: PSTenable-help.xml
Module Name: PSTenable
online version:
schema: 2.0.0
---

# Get-PSTenableAssetAnalysis

## SYNOPSIS
Returns all vulnerablitiies that are associated with a device in Tenable.

## SYNTAX

```
Get-PSTenableAssetAnalysis [-ComputerName] <String> [<CommonParameters>]
```

## DESCRIPTION
This function provides a way to retreive all vulnerabilities associated with a scanned device in Tenable.

## EXAMPLES

### EXAMPLE 1
```
Get-PSTenableAssetAnalysis -ComputerName "server.fqdn.com"
```

This retreives all vulnerabilities reported by Tenable from computername server.fqdn.com

## PARAMETERS

### -ComputerName
{{ Fill ComputerName Description }}

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
Make sure the computername is spelled correctly, otherwise the request will fail.

## RELATED LINKS
