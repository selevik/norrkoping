function Connect-Online
{
    param (
        $PathtoCred = "C:\Secrets\Cred.cred"
    )

    if (!(Get-PSSession | ? {$_.ComputerName -eq "outlook.office365.com" -and $_.State -eq "Opened"}))
    {
        #Import the function for importing credentials if it's not present
        if (!(Test-Path function:Import-PSCredential)) {. 'C:\Functions\Import-PSCredential.ps1' } 
        try
        {
	        if (Test-Path ($PathtoCred))
	        {
                $Cred = Import-PSCredential -Path $PathtoCred
            }
            else 
            {
                $Cred = Get-Credential    
            }
            
            $Session = New-PsSession -ConfigurationName Microsoft.Exchange `
                                    -ConnectionUri https://outlook.office365.com/powershell-liveid/?proxymethod=rps `
                        -Credential $Cred -Authentication Basic -AllowRedirection 
            Import-PsSession $Session -AllowClobber 
            Connect-MsolService -Credential $Cred #Deprecated 
            

	        
        }
        catch
        {
            throw "Error in Credentials section for function 'Connect-Online' $_"  
        }
    }   
}