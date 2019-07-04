# PSTenable

A PowerShell wrapper around Tenable Security Center API

## Overview

## Installation

## Examples

```
## Cache credentials and cache the tenable server
$Credential = Get-Credential
Connect-PSTenable -Credential $Credential -TenableServer "server.domain.com/rest"
```

```
## Get all devices affected by CVE-2019-0708
Get-PSTenableCVE -CVE "CVE-2019-0708"
```

```
## Get all devices affected by plugin ID 125877
Get-PSTenablePlugin -ID "125877"
```

```
## Get all vulnerabilities related to patch family Windows, Windows : Microsoft Bulletins, and Windows : User management
Get-PSTenablePluginFamilyWindows
```
