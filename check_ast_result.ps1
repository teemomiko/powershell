# Step 1: Get PC user name and PC name
$username = [Environment]::UserName
$pcName = $env:computername
$startTime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime

# Step 2: Check the path C:\Program Files (x86)\LANDesk\Shared Files\proxyhost.log
$logPath = "C:\Program Files (x86)\LANDesk\Shared Files\proxyhost.log"

if (-not (Test-Path $logPath)) {
    $message = 'No client installed'
}
else {
    # Step 3: Find proxyhost.log content and filter for ":Failed to connect to CSA with host = test-it.com"
    $logContent = Get-Content $logPath

    if ($logContent -match "Failed to connect to CSA with host = test-it.com") {
        $message = "Connection failure"

        # Find logs for the last 5 days
        $days = (Get-Date).AddDays(-3)
        $dates = $days.ToString('yyyy-MM-dd')
        Write-Output $dates
        $results = @()
        foreach ($date in $dates) {
            $formattedDate = $date
            $dailyLogs = $logContent | Select-String "Failed to connect to CSA with host = test-it.com" | Where-Object { $_ -match $formattedDate }

            if ($dailyLogs) {
                $dailyTimes = foreach ($dailyLog in $dailyLogs) {
                    $time = $dailyLog -replace '.*(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}).*', '$1'
                    [datetime]::ParseExact($time, 'yyyy-MM-dd HH:mm:ss', $null)
                }

                $mostRecentTime = $dailyTimes | Sort-Object -Descending | Select-Object -First 1
                $earliestTime = $dailyTimes | Sort-Object | Select-Object -First 1

                $results += [PSCustomObject]@{
                    Date = $formattedDate
                    MostRecentTime = $mostRecentTime
                    EarliestTime = $earliestTime
                }
            }
        }
    }
    else {
        $message = "Connection OK"
    }
}

Write-Output $message
Write-Output $results
