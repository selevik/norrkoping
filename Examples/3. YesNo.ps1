###Third
function Get-Answer ($Message)
{
    $Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes",""
    $No = New-Object System.Management.Automation.Host.ChoiceDescription "&No",""
    $choices = [System.Management.Automation.Host.ChoiceDescription[]]($Yes,$No)
    $caption = "Pick one"
    if (!$Message)
    {
        $message = "Are you sure?"
    }
    
    $result = $Host.UI.PromptForChoice($caption,$message,$choices,1) 
    if ($result -eq 0)
    {
        Write-Host "you picked Yes"
        #continue
    }
    else
    {
        Write-Host "You picked no"
    }
}