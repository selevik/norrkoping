function Import-PSCredential 
{
    param (  
        [Parameter(Position=0)]
        [string]
        #The Path where to read the XML-file with the encrypted credentials    
        $Path = "$env:APPDATA\PSCredentials.xml"
    )
     
        if (!(Test-Path ($Path)))
        {
            throw "File not found exception, exiting."
        }
     
        # Import credential file
        $import = Import-Clixml $Path
    
        if (!$import.UserName -or !$import.EncryptedPassword ) 
        {
            Throw "Input is not a valid ExportedPSCredential object, exiting."
        }
    
        try
        {
            $SecurePass = $import.EncryptedPassword | ConvertTo-SecureString -ErrorAction Stop
        }
        catch
        {
            Throw "Could not decrypt password!"
        }
    
        New-Object System.Management.Automation.PSCredential $import.Username, $SecurePass
    }
<#
.SYNOPSIS
Imports credentials from a encrypted XML-File

.DESCRIPTION
    Decrypts a password to a SecureString using Data Protection API
    Only the current user account can decrypt this cipher

.EXAMPLE
C:\PS> $Cred = Import-PSCredential
C:\PS> $Cred
UserName     Password
--------     --------
TestUser     System.Security.SecureString

.EXAMPLE
C:\PS> $Cred = Import-PSCredential -Path C:\TestUser.Cred
C:\PS> $Cred
UserName     Password
--------     --------
TestUser     System.Security.SecureString

#>