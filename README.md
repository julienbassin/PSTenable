# PSTenable

A cross-platform PowerShell Module that uses the Tenable Security Center API.

## Overview

[![Build Status](https://dev.azure.com/jwmoss/PSTenable/_apis/build/status/jwmoss.PSTenable?branchName=master)](https://dev.azure.com/jwmoss/PSTenable/_build/latest?definitionId=1&branchName=master)
[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/PSTenable.svg)](https://www.powershellgallery.com/packages/PSTenable)
[![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/PSTenable.svg)](https://www.powershellgallery.com/packages/PSTenable)

This is a PowerShell Module that functions as an API wrapper around [Tenable Security Center's API](https://docs.tenable.com/sccv/api/index.html) version 5.10. PSTenable works with Windows PowerShell 5.1 and PowerShell 6. PSTenable
automatically handles token refresh for you, specified in Tenable's documentation [here](https://docs.tenable.com/sccv/api/Token.html).

Please open a [Pull Request](https://github.com/jwmoss/PSTenable/blob/master/.github/PULL_REQUEST_TEMPLATE.md) if you desire any new features or create an [Issue](https://github.com/jwmoss/PSTenable/blob/master/.github/ISSUE_TEMPLATE.md) if you come across a bug.

## Installation

```powershell
Install-Module -Name PSTenable -Scope CurrentUser -Repository PSGallery
```

## Examples

```powershell
## Cache credentials, tenable server, web session, and token.
$Credential = Get-Credential
Connect-PSTenable -Credential $Credential -TenableServer "server.domain.com/rest" -Register

## Get all devices affected by CVE-2019-0708
Get-PSTenableCVE -CVE "CVE-2019-0708"

## Get all devices affected by plugin ID 125877
Get-PSTenablePlugin -ID "125877"

## Get all vulnerabilities related to patch family Windows, Windows : Microsoft Bulletins, and Windows : User management
Get-PSTenablePluginFamilyWindows
```
