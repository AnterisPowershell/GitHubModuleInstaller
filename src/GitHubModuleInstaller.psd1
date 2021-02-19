@{

# Version number of this module.
ModuleVersion = '0.1.0'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '66bde4a2-961b-47a3-a9e2-9d3a87886ea5'

# Author of this module
Author = 'Aidan Casey'

# Company or vendor of this module
CompanyName = 'Anteris Solutions, Inc.'

# Copyright statement for this module
Copyright = '(c) Anteris Solutions. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Provides support for finding, saving, or installing a module from GitHub.'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '7.0.0'

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @(
    'Private/GitHubModule.ps1',
    'Public/Find-GitHubBranch.ps1',
    'Public/Find-GitHubModule.ps1',
    'Public/Find-GitHubTag.ps1',
    'Public/Install-GitHubModule.ps1',
    'Public/Save-GitHubModule.ps1'
)

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
    'Find-GitHubBranch',
    'Find-GitHubModule',
    'Find-GitHubTag',
    'Install-GitHubModule',
    'Save-GitHubModule',
    'Install-GitHubModule',
    'Save-GitHubModule'
)

# Variables to export from this module
VariablesToExport = '*'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('GitHub', 'Branch', 'Tag', 'Install', 'Module', 'Save')

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/AnterisPowershell/GitHubModuleInstaller'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

