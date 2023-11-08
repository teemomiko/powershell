$minidumpPath = "$env:SystemRoot\Minidump"
$currentDate = Get-Date -Format "MM-dd-yyyy"


$infoDict = @{
 "User_Name" = $env:USERNAME
 "PC_Name" = $env:computername
 "OS" = (Get-WmiObject -Class Win32_OperatingSystem).Caption
 "Time" = $currentDate
}
function Add-SqlData {
    param (
      [Parameter(Mandatory=$true)]
      [string]$connectionString,
      
      [Parameter(Mandatory=$true)]
      [string]$insertQuery
    )
  
    $conn = New-Object System.Data.SqlClient.SqlConnection
  
    $conn.ConnectionString = $connectionString  
    $conn.Open()
  
    $cmd = New-Object System.Data.SqlClient.SqlCommand
    $cmd.Connection = $conn
    $cmd.CommandText = $insertQuery
  
    $result = $cmd.ExecuteNonQuery()
  
    $conn.Close()
  
    return $result
  }

if(Test-Path $minidumpPath){
    $files = Get-ChildItem $minidumpPath
    $fileCount = $files.Count
    $latestFile = $files | Sort-Object CreationTime -Descending | Select-Object -First 1
    $query = "INSERT INTO Table (Col1, Col2) VALUES ('a', 'b')"
    Add-SqlData -connectionString "Server=localhost;Database=test;User Id=sa;Password=123456;" -insertQuery $query
    Write-Output "Total files in $minidumpPath : $fileCount"
    Write-Output "Latest file: $($latestFile.Name)"
}


Write-Output $infoDict.User_Name,$infoDict.PC_Name