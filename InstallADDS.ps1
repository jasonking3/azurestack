configuration InstallADDS
{
    param 
    ( 
        [Parameter(Mandatory)] 
        [string] $safemodePassword, 
        [Parameter(Mandatory)] 
        [string] $domainPassword
        # [PSCredential] $domainCred,
        # [PSCredential] $safemodeAdministratorCred
        # [Parameter(Mandatory)] 
        # [pscredential]$DNSDelegationCred, 
        # [Parameter(Mandatory)] 
        # [pscredential]$NewADUserCred 
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration, xActiveDirectory
    
    $secureSafemodePassword = ConvertTo-SecureString $safemodePassword -AsPlainText -Force
    [PSCredential]$safemodeAdministratorCred = New-Object System.Management.Automation.PSCredential ("Administrator", $secureSafemodePassword)

    $secureDomainPassword = ConvertTo-SecureString $domainPassword -AsPlainText -Force
    [PSCredential]$domainCred = New-Object System.Management.Automation.PSCredential ("Administrator", $secureDomainPassword)

    node "localhost"
    {
        # Install Domain Services role
        WindowsFeature ADDSInstall
        {
            Ensure = "Present"
            Name = "AD-Domain-Services"
        }

        # Optional GUI tools            
        WindowsFeature ADDSTools            
        {             
            Ensure = "Present"             
            Name = "RSAT-ADDS"             
        }            
       
        xADDomain FirstDS
        {
            DomainName = "ad.ciscops.net" 
            DomainAdministratorCredential = $domainCred 
            SafemodeAdministratorPassword = $safemodeAdministratorCred 
            # DnsDelegationCredential = $DNSDelegationCred 
            DependsOn = "[WindowsFeature]ADDSInstall" 
        }
    }
}

$ConfigData = @{
    AllNodes = @(
        @{ NodeName="localhost"; PSDscAllowPlainTextPassword = $true }
)}

InstallADDS -ConfigurationData $ConfigData