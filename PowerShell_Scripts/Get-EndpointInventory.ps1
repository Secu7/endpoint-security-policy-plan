<#
.SYNOPSIS
Collects basic hardware and software inventory from Windows endpoints.
.DESCRIPTION
Gathers essential device information for endpoint tracking and device refresh planning.
Outputs data that can be imported into ServiceNow or exported to CSV for reporting.
#>

# Get basic system information
$ComputerInfo = Get-ComputerInfo
$DiskInfo = Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3}

# Create inventory object
$Inventory = [PSCustomObject]@{
    ComputerName = $env:COMPUTERNAME
    SerialNumber = $ComputerInfo.CsSystemSKUNumber
    Model = $ComputerInfo.CsModel
    Manufacturer = $ComputerInfo.CsManufacturer
    OSVersion = $ComputerInfo.WindowsVersion
    TotalRAM_GB = [Math]::Round($ComputerInfo.TotalPhysicalMemory / 1GB, 2)
    DiskSpace_GB = [Math]::Round(($DiskInfo | Measure-Object -Property Size -Sum).Sum / 1GB, 2)
    LastBootTime = $ComputerInfo.CsLastBootUpTime
    CollectionDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
}

# Output for MECM or Intune collection
$Inventory | ConvertTo-Json