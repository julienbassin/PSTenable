# Change Log

## [0.2.1] 2019-07-13

- Re-worked how to automatically retrive a new token.

## [0.2.0] 2019-07-12

- Added Get-PSTenableWindowsServerJava
- Fixed issue with Get-PSTenablePlugin output

## [0.1.3] 2019-07-09

- Added feature in Invoke-PSTenableRest to enable TLS 1.2 and restoring TLS settings, used in [KBUpdate](https://github.com/potatoqualitee/kbupdate).
- Added feature in Connect-PSTenable to automatically fix Invoke-RestMethod if hostname isn't using TLS.
- Formatting changes for a handful of functions.

## [0.1.2] 2019-07-05

- Initial upload to gallery
- Fixed changelog date to ISO 8061. Derp.

## [0.1.1] 2019-07-04

- Initial upload
- Converted Invoke-RestMethod to Invoke-PSTenableRest
- Added basic support for caching token, web seession, and credential using PSFramework
- Added basic help/readme support
