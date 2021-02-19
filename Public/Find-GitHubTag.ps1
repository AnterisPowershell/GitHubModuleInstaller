<#
 .Synopsis
  Finds a specific tag on a GitHub repository.

 .Description
  Attempts to find the referenced tag on the passed repository name. If found,
  an instance of [GitHubModule] is returned.

 .Parameter Repository
  The name of the repository to find (e.g. "AnterisPowershell/Core").

 .Parameter Tag
  The name of the tag to find (e.g. "v0.1.0").

 .Example
  Find-GitHubTag "AnterisPowershell/Core" "v0.1.0"

  Finds the tag "v0.1.0" on the repository "AnterisPowershell/Core."
#>
function Find-GitHubTag
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $Repository,

        [Parameter(Mandatory=$true)]
        [Version] $Tag
    )

    Write-Verbose "Checking $($Repository) for an available version $($Tag).";

    # First set our TLS version to 1.2.
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

    # Now look for our tag.
    $gitHubVersion = $false;
    $page = 1;

    while($gitHubVersion -eq $false) {
        $uri = "https://api.github.com/repos/$($Repository)/tags?per_page=100&page=$($page)";
        $gitHubTags = Invoke-RestMethod -Uri $uri;

        if (-not($gitHubTags)) {
            break;
        }

        foreach ($gitHubTag in $gitHubTags) {
            # If the version is prefixed by "v" (e.g. "v0.1.0") remove the "v".
            try {
                $gitHubTagName = $gitHubTag.name.ToLower().Replace('v', '');
                $gitHubTagVersion = New-Object "System.Version" $gitHubTagName;
            } catch {
                continue;
            }

            switch ($Tag.CompareTo($gitHubTagVersion)) {
                -1 {
                    # Version is older, keep looking.
                    continue;
                }

                0 {
                    # Version found!
                    $gitHubVersion = $gitHubTag;
                }

                1 {
                    # Version is newer compared to the GitHub version, which means we can stop searching
                    break;
                }
            }
        }

        $page++;
    }

    if (-not $gitHubVersion) {
        throw("No match was found for the specified search criteria and module name `"$($Repository)`".");
    }

    return [GitHubModule]::new(
        $Repository,
        $Tag,
        $gitHubVersion.zipball_url
    );
    # return @{
    #     Name = $Repository.split('/')[-1]
    #     Repository = $Repository
    #     Download = $gitHubVersion.zipball_url
    #     Version = $Tag
    # }
}
