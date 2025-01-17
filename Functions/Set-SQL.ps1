function Set-SQL
{
	param (
		[string]$Query,
		[string]$ConnString,
		[System.Data.SQLClient.SQLConnection]$Connection = (New-Object System.Data.SQLClient.SQLConnection),
		[switch]$KeepConnectionAlive,
		[switch]$ExecuteAsReader
	) 
	
	if ($ConnString) {
	
		if($ConnString -match '"*"') {
			$ConnString = $ConnString.TrimStart('"')
			$ConnString = $ConnString.TrimEnd('"')
		}	
    } 
    else 
    {	
		# Default ConnectionString
		$ConnString = "server=mssql;database=db;trusted_connection=true;"	
	}
	
	if ($Connection.State -eq "Closed")
	{
		$Connection.ConnectionString = $ConnString
		$Connection.Open()
	}
	
	$Command = New-Object System.Data.SQLClient.SQLCommand
	$Command.Connection = $Connection
	$Command.CommandText = $Query
	
	if ($ExecuteAsReader) {
		$Reader = $Command.ExecuteReader() }
	else {
		$Reader = $Command.ExecuteNonQuery() }
	
	if (!$KeepConnectionAlive) { $Connection.Close() }
	
	return $Reader 
}
    <#
    .SYNOPSIS
    Inserts into an SQL-db
    
    .DESCRIPTION
    Inserts an SQL-query into a DB. Switch -KeepConnectionAlive can be used to keep the connection open. -ExecuteAsReader returns an object
    
    .EXAMPLE
    C:\PS> Set-SQL -Query "Drop * from dbo.Test"
    1 rows affected
        
    #>