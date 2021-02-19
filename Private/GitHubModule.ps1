<#
 Represents a GitHub Module, providing information on its name, version, and
 the best location to download it.
#>
class GitHubModule
{
    [string] $Name
    [string] $Repository
    [string] $Version
    [string] $Download

    GitHubModule([string] $Repository, [string] $Version, [string] $Download)
    {
        $this.Name = $Repository.split('/')[-1];
        $this.Repository = $Repository;
        $this.Version = $Version;
        $this.Download = $Download;
    }
}
