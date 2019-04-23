
function Import-PSCredential {

    param ( 
        [Parameter(Position=0)]
        [string]
        #The Path where to read the XML-file with the encrypted credentials	
        $Path = "$env:APPDATA\PScredentials.enc.xml"
    )
        
    Begin {
        if (!(Test-Path ($Path)))
        {
            throw "File not found exception, exiting."
        }
    }
    Process {
        # Import credential file
        $import = Import-Clixml $Path
    
        if (!$import.UserName -or !$import.EncryptedPassword ) 
        {
            Throw "Input is not a valid ExportedPSCredential object, exiting."
        }
    
        $Username = $import.Username
        try
        {
            $SecurePass = $import.EncryptedPassword | ConvertTo-SecureString -ErrorAction Stop
        }
        catch
        {
            Throw "Could not decrypt password!"
        }
    
        $Credential = New-Object System.Management.Automation.PSCredential $Username, $SecurePass
    }
    End {
        $Credential
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
    
    }
    Export-ModuleMember -Function 'Import-PSCredential'
    
    function Export-PSCredential {
    
    param ( 
        [Parameter(Position=0)]
        #Pass Credential or UserName to the Cmdlet or get prompted 
        $Credential = (Get-Credential), 
        
        [Parameter(Position=1)]
        [string]
        #The Path where to store the XML-file with the encrypted credentials	
        $Path = "$env:APPDATA\PScredentials.enc.xml"
    )
        
    Begin {
        switch ($Credential.GetType().Name ) 
        {
            PSCredential { continue }
            String { $Credential = Get-Credential -credential $Credential }
            default { Throw "You must specify a credential object to export to disk." }
        }
    
        if (Test-Path ($Path))
        {
            $Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes",""
            $No = New-Object System.Management.Automation.Host.ChoiceDescription "&No",""
            $choices = [System.Management.Automation.Host.ChoiceDescription[]]($Yes,$No)
            $caption = "The file `'$Path`' already exists!"
            $message = "Do you want to replace it?"
            $result = $Host.UI.PromptForChoice($caption,$message,$choices,1)
    
            if ($result -eq 1)
            {
                break
            }
        }    
    }
    Process {
        $export = "" | Select-Object Username, EncryptedPassword
    
        $export.PSObject.TypeNames.Insert(0,’ExportedPSCredential’)
        $export.Username = $Credential.Username
        
        # Encrypt SecureString password using Data Protection API
        $export.EncryptedPassword = $Credential.Password | ConvertFrom-SecureString
        
        $export | Export-Clixml $Path
    }
    End {
        $Credential
    }
    <#
    .SYNOPSIS
    Exports Credentials to a encrypted XML-File
    
    .DESCRIPTION
     Encrypt SecureString password using Data Protection API
     Only the current user account can decrypt this cipher from the same computer
    
    .EXAMPLE
    C:\PS> $Cred = Get-Credential TestUser
    cmdlet Get-Credential at command pipeline position 1
    Supply values for the following parameters:
    
    C:\PS> Export-PSCredential $Cred
    UserName     Password
    --------     --------
    TestUser     System.Security.SecureString
    
    .EXAMPLE
    C:\PS> Export-PSCredential TestUser -Path C:\TestUser.cred
    UserName     Password
    --------     --------
    TestUser     System.Security.SecureString
    
    #>
    
}
    
    Export-ModuleMember -Function 'Export-PSCredential'