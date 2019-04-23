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