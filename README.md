# PSTenable

A PowerShell wrapper around Tenable Security Center API

## Overview

This is a PowerShell Module that I developed that is an API wrapper around [Tenable Security Center's API](https://docs.tenable.com/sccv/api/index.html).

## Installation

```
git clone https://github.com/jwmoss/PSTenable.git
Import-Module .\PSTenable\PSTenable.psm1
```

## Examples

```
## Cache credentials, tenable server, web session, and token
$Credential = Get-Credential
Connect-PSTenable -Credential $Credential -TenableServer "server.domain.com/rest" -Register
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
