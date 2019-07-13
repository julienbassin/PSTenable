---
external help file: PSTenable-help.xml
Module Name: PSTenable
online version:
schema: 2.0.0
---

# Get-PSTenableWindowsServerJava

## SYNOPSIS
Retrieves all devices that are have an old version of Java, with a high or critical rating.

## SYNTAX

```
Get-PSTenableWindowsServerJava [<CommonParameters>]
```

## DESCRIPTION
This function provides a way to retrieves all devices that are have an old version of Java, with a high or critical rating.

## EXAMPLES

### EXAMPLE 1
```
Get-PSTenableWindowsServerJava
```

This retrieves Java vulnerabilities that are high or critical for Windows hosts.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### None
## NOTES
Helpful for retrieving all instances of Java running in your environment that is insecure.

## RELATED LINKS
