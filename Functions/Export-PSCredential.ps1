function Export-PSCredential 
{
    param (  
        [Parameter(Position=0)]
        [PSCredential]
        #Pass Credential or UserName to the Cmdlet or get prompted for credentials
        $Credential = (Get-Credential), 

        [Parameter(Position=1)]
        [string]
        #The Path where to store the XML-file with the encrypted credentials.     
        $Path = "$env:APPDATA\PSCredentials.xml"
    )

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
    $export = "" | Select-Object Username, EncryptedPassword

    $export.PSObject.TypeNames.Insert(0,’ExportedPSCredential’)
    $export.Username = $Credential.Username

    # Encrypt SecureString password using Data Protection API
    # Only the current user account can decrypt this cipher
    $export.EncryptedPassword = $Credential.Password | ConvertFrom-SecureString

    $export | Export-Clixml $Path

    return $Credential
}