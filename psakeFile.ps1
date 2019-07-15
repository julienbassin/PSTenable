properties {
    # Disable "compiling" module into monolithinc PSM1.
    # This modifies the default behavior from the "Build" task
    # in the PowerShellBuild shared psake task module
    $PSBPreference.Build.CompileModule = $false
    $moduleName = $env:BHProjectName
    $manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
    $outputDir = Join-Path -Path $ENV:BHProjectPath -ChildPath 'Output'
    $outputModDir = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
}

task default -depends Test

task Test -FromModule PowerShellBuild -Version '0.3.1'

task PublishToPSGallery -Action {

    ## https://github.com/KevinMarquette/PSGraph/blob/master/BuildTasks/PublishModule.Task.ps1

    if ($ENV:BHBranchName -eq "master" -and
        $ENV:BHCommitMessage -match "!deploy" -and
        -not [string]::IsNullOrWhiteSpace($ENV:API)) {

        $publishModuleSplat = @{
            Path        = $outputModDir
            NuGetApiKey = $env:API
            Verbose     = $true
            Force       = $true
            ErrorAction = 'Stop'
        }
        "Files in module output:"
        Get-ChildItem $outputModDir -Recurse -File | Select-Object -Expand FullName

        "Publishing [$Destination] to [Powershell Gallery]"

        Publish-Module @publishModuleSplat
    }

    else {
        "Skipping deployment: To deploy, ensure that...`n" +
        "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n" +
        "`t* The repository APIKey is defined in `$ENV:nugetapikey (Current: $(![string]::IsNullOrWhiteSpace($ENV:API)))) `n" +
        "`t* This is not a pull request"
    }
}
