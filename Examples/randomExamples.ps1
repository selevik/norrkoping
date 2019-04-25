$A = "2"


#Arrays
$b = @("Andreas","Fredrik",1,@("Maria","Fredrik"))

$b | ForEach-Object {$_ | % {$_}} 

$b | ForEach-Object {
    $_ | % {
        $_
    }
} 

foreach ($entry in $b)
{
    foreach ($subEntry in $entry)
    {
        $subEntry 
    }
}

#Hashtable
foreach ($key in $HashTable.Keys)
{
    Write-Host "$key" -ForegroundColor Yellow
    $HashTable.$key


}


##.Net

$Appdomain = [System.AppDomain]::CurrentDomain


#Alias
Get-ChildItem C:\_kod -Recurse -include *.ps1 | ForEach-Object {
    Get-Content $_ | Select-String "instance"

}


#Alias
foreach ($item in (Get-ChildItem C:\_kod -Recurse -include *.ps1))
{
    Get-Content $item | Where-Object {$_ -clike "*instance*"}
}

###Fourth
function Get-Answer ($Message)
{
    $Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes",""
    $No = New-Object System.Management.Automation.Host.ChoiceDescription "&No",""
    $Maybe = New-Object System.Management.Automation.Host.ChoiceDescription "&Maybe",""
    $choices = [System.Management.Automation.Host.ChoiceDescription[]]($Yes,$No,$Maybe)
    $caption = "Pick one"
    if (!$Message)
    {
        $message = "Are you sure?"
    }
    
    $result = $Host.UI.PromptForChoice($caption,$message,$choices,1) 
    if ($result -eq 0)
    {
        Write-Host "you picked Yes"
        return $true
        #continue
    }
    elseif ($result -eq 1)
    {
        Write-Host "You picked no"
        return $false
    }
    else 
    {
        Write-Host "Maybe?!?!"
    }
}

#Alias
foreach ($item in (Get-ChildItem C:\_kod -Recurse -include *.ps1))
{
    if (Get-Answer -Message "Do you want to open $($item.FullName)?")
    {
        Get-Content $item 
    }
}



$export = @()
foreach ($item in (Get-ChildItem C:\_kod -Recurse -include *.ps1))
{
    $export += $item | Select-Object Name,LastWriteTime
}
$export | Where-Object {$_.LastWriteTime -gt "2019-04-23"}



$export = foreach ($item in (Get-ChildItem C:\_kod -Recurse -include *.ps1))
{
    $item | Select-Object Name,LastWriteTime
    
}

$export | Where-Object {$_.LastWriteTime -gt "2019-04-23"}

#Functions
function Get-Message
{
    Write-Host "Hello"
}


function Divide-Number
{
    param (
        [int]$Number
    )

    try
    {
        4/$Number
    }
    catch
    {
        $DateNow = Get-Date
        $DateLogFormat = $DateNow.ToString("yyyyMMdd_hhmm")
        $DateLogFormat = (Get-Date).ToString("yyyyMMdd_hhmm")
        

        Add-Content -Value "$((Get-Date).ToString("yyyyMMdd_hhmm")) $($_.Exception)" -Path C:\_kod\norrkoping\Examples\errorLog.txt
        
        #Andreas rekommenderar
        $ErrorMsg = "{0} - {1}" -f ($DateLogFormat,$_.Exception, "AndreasÄrBäst")
        Add-Content -Value $ErrorMsg -Path C:\_kod\norrkoping\Examples\errorLog.txt
    }
}

###Credentials

$Cred = Get-Credential 
$Cred.UserName
$Cred.Password | ConvertFrom-SecureString

$Cred.GetNetworkCredential().Password

. C:\_kod\norrkoping\Functions\Import-PSCredential.ps1

## "Picker"

Get-ADuser -filter {displayName -like "*Ekström"} | Out-GridView -PassThru

