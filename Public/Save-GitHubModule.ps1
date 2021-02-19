<#
 .Synopsis
  Downloads a module from GitHub to the specificed location.

 .Description
  Downloads the source code of a module stored on GitHub to the specified path.

 .Parameter Repository
  The repository to download from (e.g. "AnterisPowershell/Core").

 .Parameter Version
  The version of the module to download.

 .Parameter Path
  The path to download the module to.

 .Example
  Save-GitHubModule -Name "AnterisPowershell/Core" -Version "v0.1.0" -Path "$(Get-Location)/vendor"
#>
function Save-GitHubModule
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $Repository,

        [string] $Version = 'main',

        [Parameter(Mandatory=$true)]
        $Path
    )

    Process {
        $gitHubModule = Find-GitHubModule $Repository $Version;
        Write-Verbose "Module has been found at $($gitHubModule.Download).";

        # Create a temporary directory to download this module to.
        $tempDir = Join-Path -path ([System.IO.Path]::GetTempPath()) -childpath ([System.Guid]::NewGuid());
        $tempFile = Join-Path -path $($tempDir) -childpath "$($gitHubModule.Name).zip";

        $null = New-Item -ItemType Directory -Path $tempDir -Force

        # Download the file.
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

        try {
            Invoke-WebRequest $gitHubModule.Download -OutFile $tempFile;
        } catch {
            throw("We were unable to download the file from $($gitHubModule.Download)!");
        }

        # Extract the zip archive to the temp directory.
        $fileHash = $(Get-FileHash -Path $tempFile).hash;
        $unzippedDir = Join-Path -Path $tempDir -ChildPath $fileHash;

        Expand-Archive -Path $tempFile -DestinationPath $unzippedDir -Force;

        # Reset the unzipped dir context to the sub-directory created when expanding.
        $unzippedDir = (Get-ChildItem $unzippedDir)[-1];

        # Setup the destination environment.
        $Path = Join-Path -Path $Path -ChildPath $gitHubModule.Name;

        # Set the unzipped directory to the context of a sub-folder if nested.
        $module = Get-ChildItem $unzippedDir -Filter "*.psm1" -File -Recurse;

        if ($module) {
            $unzippedDir = $module.Directory.FullName;
        }

        # If there is a version included in the manifest, place the source within
        # a sub-directory with that version number.
        $manifest = Get-ChildItem $unzippedDir -Filter "*.psd1" -File -Recurse

        if ($manifest) {
            $moduleVersion = (Get-Content -Raw $manifest.FullName | Invoke-Expression).ModuleVersion;
            $Path = Join-Path -Path $Path -ChildPath $moduleVersion;
        }

        # Copy the source code.
        $null = New-Item -ItemType Directory -Path $Path -Force;

        # Now copy all the contents of the zip archive to this path.
        Write-Verbose -Message "Copying contents of $($unzippedDir) to $($Path).";
        $null = Copy-Item "$($unzippedDir)\*" $Path -Force -Recurse

        # Finally cleanup our mess.
        Write-Verbose -Message "Removing $($tempDir).";
        $null = Remove-Item $tempDir -Recurse -Force;
    }
}
