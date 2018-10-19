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