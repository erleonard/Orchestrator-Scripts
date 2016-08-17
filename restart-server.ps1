<#
===========================================================================
	 Created on:   	8/16/2016 8:00pm
	 Created by:   	Eric Leonard
	 Organization: 	N/A
	 Filename:      Restart-Server.ps1
=========================================================================== 
#>[int]$ReturnCode = 0[string]$ReturnText = ''
[string]$Server = ""

Try {
    Restart-Computer -ComputerName $Server -Wait -For WinRM -Timeout 180 -Force -ErrorAction Stop
    $ReturnCode = 0
    $ReturnText = "Success"
}
catch [System.InvalidOperationException] {
    if ($_.Exception.Message -like '*0x80070005*') {
        $ReturnCode = 1
        $ReturnText = "System access is denied. please provide proper credentials"
    }
    elseif ($_.Exception.Message -like '*0x800706BA*') {
        $ReturnCode = 1
        $ReturnText = "system is not reachable or blocked by firewall"
    }
    else {
    $ReturnCode = 1
    $ReturnText = "$_.Exception.Message"
    }
}
catch [Microsoft.PowerShell.Commands.RestartComputerTimeoutException] {
    $ReturnCode = 1
    $ReturnText = "System reboot has timed out. Max is 10min"
}

Write-Host $ReturnCode -ForegroundColor Yellow
Write-Host $Returntext -ForegroundColor Cyan