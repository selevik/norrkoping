function Get-SQL
{
	param (
		[parameter(Mandatory=$true)][string]$Query,
		[string]$ConnString,
		[System.Data.SQLClient.SQLConnection]$Connection = (New-Object System.Data.SQLClient.SQLConnection),
		[switch]$KeepConnectionAlive
	) 

	if ($ConnString) {

	if($ConnString -match '"*"') {
		$ConnString = $ConnString.TrimStart('"')
		$ConnString = $ConnString.TrimEnd('"')
	}

    } 
    else 
    {

        # Default Connection String
        $ConnString =
        "server=mssql;database=db;trusted_connection=true;"
        }

        #$Connection = New-Object System.Data.SQLClient.SQLConnection

        $Connection.ConnectionString = $ConnString
        $Connection.Open()

        $Command = New-Object System.Data.SQLClient.SQLCommand
        $Command.Connection = $Connection
        $Command.CommandText = $Query

        $Reader = $Command.ExecuteReader()
        $Counter = $Reader.FieldCount
        while ($Reader.Read()) {
            $SQLObject = @{}
                for ($i = 0; $i -lt $Counter; $i++) {
                    $SQLObject.Add(
                    $Reader.GetName($i),
                    $Reader.GetValue($i));
                }
            $SQLObject
	}

	if (!$KeepConnectionAlive) { $Connection.Close() }
}