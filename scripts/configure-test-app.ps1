<#
    .SYNOPSIS
        Downloads and configures .Net Core web api Store application sample across IIS and Azure SQL DB.
#>

Param (
    [string]$api1ipaddress,
    [string]$api2ipaddress,
    [string]$connectionstring
)

# Firewall
netsh advfirewall firewall add rule name="http" dir=in action=allow protocol=TCP localport=80

# Folders
New-Item -ItemType Directory c:\temp
New-Item -ItemType Directory c:\webapi

# Install iis
Install-WindowsFeature web-server -IncludeManagementTools

# Install dot.net core sdk
Invoke-WebRequest http://go.microsoft.com/fwlink/?LinkID=615460 -outfile c:\temp\vc_redistx64.exe
Start-Process c:\temp\vc_redistx64.exe -ArgumentList '/quiet' -Wait
Invoke-WebRequest https://download.microsoft.com/download/1/1/5/115B762D-2B41-4AF3-9A63-92D9680B9409/dotnet-sdk-2.1.4-win-x64.exe -outfile c:\temp\dotnet-sdk-2.1.4-win-x64.exe
Start-Process c:\temp\dotnet-sdk-2.1.4-win-x64.exe -ArgumentList '/quiet' -Wait
Invoke-WebRequest https://download.microsoft.com/download/1/1/0/11046135-4207-40D3-A795-13ECEA741B32/DotNetCore.2.0.5-WindowsHosting.exe -outfile c:\temp\DotNetCore.2.0.5-WindowsHosting.exe
Start-Process c:\temp\DotNetCore.2.0.5-WindowsHosting.exe -ArgumentList '/quiet' -Wait

# Download webapi app
Invoke-WebRequest https://github.com/kryvoplias/arm-template/raw/master/test-app/WebApiTestApp.zip -OutFile c:\temp\WebApiTestApp.zip
Expand-Archive C:\temp\WebApiTestApp.zip c:\webapi

# Azure SQL connection sting in environment variable
[Environment]::SetEnvironmentVariable("Data:ConnectionString", "$connectionstring",[EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("Data:Api1IpAddress", "$api1ipaddress",[EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("Data:Api2IpAddress", "$api2ipaddress",[EnvironmentVariableTarget]::Machine)

# Pre-create database
$env:Data:ConnectionString = "$connectionstring"
$env:Data:Api1IpAddress = "$api1ipaddress"
$env:Data:Api2IpAddress = "$api2ipaddress"
Start-Process 'C:\Program Files\dotnet\dotnet.exe' -ArgumentList 'c:\webapi\WebApiTestApp.dll'

# Configure iis
Remove-WebSite -Name "Default Web Site"
Set-ItemProperty IIS:\AppPools\DefaultAppPool\ managedRuntimeVersion ""
New-Website -Name "WebApiTestApp" -Port 80 -PhysicalPath C:\webapi\ -ApplicationPool DefaultAppPool
& iisreset