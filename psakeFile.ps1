properties {
    # Disable "compiling" module into monolithinc PSM1.
    # This modifies the default behavior from the "Build" task
    # in the PowerShellBuild shared psake task module
    $PSBPreference.Build.CompileModule = $false
    $moduleName = $env:BHProjectName
    $manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
    $outputDir = Join-Path -Path $ENV:BHProjectPath -ChildPath 'Output'
    $outputModDir = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
    $outputModVerDir = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion
}

task default -depends Test

task Test -FromModule PowerShellBuild -Version '0.3.1'

task PublishToPSGallery -action {
    Try {
        $Splat = @{
            Path        = $outputModDir
            NuGetApiKey = $env:API
            ErrorAction = 'Stop'
        }

        Publish-Module @Splat

    } Catch {
        throw $_
    }
}
