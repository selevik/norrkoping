###First
function Get-Answer
{
    $Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes",""
    $No = New-Object System.Management.Automation.Host.ChoiceDescription "&No",""
    $choices = [System.Management.Automation.Host.ChoiceDescription[]]($Yes,$No)
    $caption = "Pick one"
    $message = "Are you sure?"
    $result = $Host.UI.PromptForChoice($caption,$message,$choices,1) 
}
