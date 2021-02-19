<#
 .Synopsis
  Finds a specific branch on a GitHub repository.

 .Description
  Attempts to find the referenced branch on the passed repository name. If found,
  an instance of [GitHubModule] is returned.

 .Parameter Repository
  The name of the repository to find (e.g. "AnterisPowershell/Core").

 .Parameter Branch
  The name of the branch to find (e.g. "master").

 .Example
  Find-GitHubBranch "AnterisPowershell/Core" "master"

  Finds the "master" branch on the repository "AnterisPowershell/Core."
#>
function Find-GitHubBranch
{
    param (
        [Parameter(Mandatory=$true)]
        [string] $Repository,

        [Parameter(Mandatory=$true)]
        [string] $Branch
    )

    Process {
        Write-Verbose "Checking $($Repository) for an available branch $($Branch).";

        # First set our TLS version to 1.2.
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

        try {
            $branchDetails = Invoke-RestMethod -Uri "https://api.github.com/repos/$($Repository)/branches/$($Branch)";
        } catch {
            throw("No match was found for the specified search criteria and repository name `"$($Repository)`".");
        }

        return [GitHubModule]::new(
            $Repository,
            $Branch,
            "https://github.com/$($Repository)/archive/$($Branch).zip"
        );
    }
}
