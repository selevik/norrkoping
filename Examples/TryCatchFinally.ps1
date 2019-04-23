$i = 0
$numbers = @(0,1,2,"tre") #array with ints and strings
Foreach ($number in $numbers)
{
    try
    {
        #do something
        Write-host "1/$number : " -NoNewline
        $result = 1/$number
        
        #only comes here if you actually succeeded and did not get an error
        Write-host "$result" -ForegroundColor Green
    }
    catch [System.Management.Automation.PSInvalidCastException] #catch all PSInvalidCastException errors
    {
        Write-Host "Warning! " -ForegroundColor Yellow -NoNewline
        Write-Host "Cannot divde with string"
    }
    catch #catch all errors not already beeing caught
    {
        Write-Host "Error! " -ForegroundColor Red -NoNewline
        Write-host "$_"
    }
    finally #always run this, used for clearing up connections, logging etc
    {
        $i++
    }
}
Write-Host "`nLooped $i times"
