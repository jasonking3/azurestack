# Required to install PSGallery modules
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Required to use xADDomain in DSC
Install-Module -Name xActiveDirectory -Force

# Configure required LCM settings
[DSCLocalConfigurationManager()]
configuration ConfigureLCM
{
    Node localhost
    {
        Settings
        {
            RebootNodeIfNeeded = $true
        }
    }
}

ConfigureLCM

Set-DscLocalConfigurationManager -Path ConfigureLCM