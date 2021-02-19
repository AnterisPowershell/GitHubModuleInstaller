<#
 .Synopsis
  Finds the referenced repository and version by checking available branches and tags.

 .Description
  Checks the specified repository to see if there are any branches that match the
  referenced version. If not, it then checks to see if any tags do. If a match
  is found, an instance of [GitHubModule] is returned.

 .Parameter Repository
  The repository to be checked.

 .Parameter Version
  The version to check for.
#>
function Find-GitHubModule
{
    [CmdletBinding()]
    param (
        [string] $Repository,
        [string] $Version
    )

    Process {
        # First try to find the GitHub branch since that will be faster to respond.
        try {
            $branch = Find-GitHubBranch $Repository $Version;
            return $branch;
        } catch {
            Write-Verbose "The referenced version `"$($Version)`" does not exist as a branch.";
        }

        # Next try to find a GitHub tag.
        try {
            $tag = Find-GitHubTag $Repository $Version;
            return $tag;
        } catch {
            Write-Verbose "The referenced version `"$($Version)`" does not exist as a tag.";
        }

        throw("No match was found for the specified search criteria and repository name `"$($Repository)`".");
    }
}
