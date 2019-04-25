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

