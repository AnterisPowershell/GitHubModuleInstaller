<#
 .Synopsis
  Installs a module from GitHub source code.

 .Description
  Downloads the source code of a module stored on GitHub to the global module path.

 .Parameter Repository
  The repository to download from (e.g. "AnterisPowershell/Core").

 .Parameter Version
  Which version of the module to download.

 .Example
  Install-GitHubModule -Name "AnterisPowershell/Core" -Version "v0.1.0"
#>
function Install-GitHubModule
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $Repository,

        [string] $Version = 'main'
    )

    Process {
        # If no path is specified, install to one of our global module directories.
        if ($IsLinux -or $IsMacOS) {
            $Path = Join-Path -Path $HOME -ChildPath ".local/share/powershell/Modules";
        } else {
            $Path = "$($env:SystemDrive)\Program Files\WindowsPowershell\Modules";
        }

        return Save-GitHubModule -Repository $Repository -Version $Version -Path $Path;
    }
}
