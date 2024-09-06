@echo off
:: ---------------------------------------
:: Erik's PC Tweaking Tool - Professional Version
:: ---------------------------------------
:: Check if running as admin
openfiles >nul 2>&1
if '%errorlevel%' neq '0' (
    echo You need to run this script as an administrator.
    pause
    exit /b
)

:: Create a system restore point
echo Creating system restore point...
powershell -command "Checkpoint-Computer -Description 'Pre-Tweaks Restore Point' -RestorePointType MODIFY_SETTINGS"
echo.

:: Display Menu
:menu
cls
echo =====================================
echo                Erik's
echo           PC TWEAKING TOOL
echo =====================================
echo                MENU
echo =====================================
echo 1. Install reviOS
echo 2. Install Profile Inspector
echo 3. Optimize PC
echo 4. Exit
echo =====================================
echo Credit to Chris Titus and Lecctron for all tweaks.
set /p choice="Please enter your choice (1-4): "

if "%choice%" == "1" goto install_revios
if "%choice%" == "2" goto install_profile_inspector
if "%choice%" == "3" goto optimize_pc
if "%choice%" == "4" goto exit_script
goto menu

:: Option 1 - Install reviOS
:install_revios
echo Downloading reviOS...
start https://revi.cc/revios/download/
timeout /t 5
goto menu

:: Option 2 - Install Profile Inspector
:install_profile_inspector
echo Installing Profile Inspector...
start https://github.com/Orbmu2k/nvidiaProfileInspector/releases
timeout /t 5
goto menu

:: Option 3 - Optimize PC for Gaming
:optimize_pc
cls
echo Optimizing PC for Gaming...

:: Enable Hardware-Accelerated GPU Scheduling
echo Enabling Hardware-Accelerated GPU Scheduling...
powershell -Command "if (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\HardwareSettings\HWSchMode') { Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\HardwareSettings' -Name 'HWSchMode' -Value 2 -Force }"

:: Enable Optimization for Windowed Games
echo Enabling Optimization for Windowed Games...
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoHDRUserConsent" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\GameBar" /v "PerfWaitMult" /t REG_DWORD /d 1 /f

:: Add Fortnite to High Performance Graphics Settings
echo Adding Fortnite to High Performance Graphics Settings...
powershell -Command "& {Add-AppxPackage -register 'C:\Windows\System32\GraphicsPerfSvc.dll'; Start-Sleep -Seconds 2; $graphicsPath = 'HKCU:\Software\Microsoft\DirectX\UserGpuPreferences'; if (-not (Test-Path $graphicsPath)) { New-Item -Path $graphicsPath -Force }; Set-ItemProperty -Path $graphicsPath -Name 'C:\Path\To\Fortnite\FortniteClient-Win64-Shipping.exe' -Value 'GpuPreference=2;' -Force }"

:: Enable Game Mode
echo Enabling Game Mode...
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f

:: Delete Temporary Files
echo Deleting temporary files...
del /q /s /f %TEMP%\*
del /q /s /f C:\Windows\Temp\*

:: Disable Consumer Features
echo Disabling consumer features...
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CloudExperienceHost\FeatureManagement\Overrides" /v "EnabledState" /t REG_DWORD /d 1 /f

:: Disable Telemetry
echo Disabling telemetry...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f

:: Disable Activity History
echo Disabling activity history...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d 0 /f

:: Disable GameDVR
echo Disabling GameDVR...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f

:: Disable Hibernation
echo Disabling hibernation...
powercfg -h off

:: Disable HomeGroup
echo Disabling HomeGroup services...
sc config "HomeGroupListener" start= disabled
sc config "HomeGroupProvider" start= disabled

:: Prefer IPv4 over IPv6
echo Preferring IPv4 over IPv6...
netsh interface ipv6 set global randomizeidentifiers=disabled
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v "DisabledComponents" /t REG_DWORD /d 0x20 /f

:: Disable Location Tracking
echo Disabling location tracking...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d 1 /f

:: Disable Storage Sense
echo Disabling Storage Sense...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\StorageSense" /v "AllowStorageSenseGlobal" /t REG_DWORD /d 0 /f

:: Enable End Task with Right Click in Taskbar
echo Enabling end task with right-click...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableTaskMgr" /t REG_DWORD /d 0 /f

:: Run Disk Cleanup
echo Running disk cleanup...
cleanmgr /sagerun:1

:: Change Windows Terminal Default to PowerShell 7
echo Changing Windows Terminal default to PowerShell 7...
reg add "HKCU\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" /v "Target" /t REG_SZ /d "%ProgramFiles%\PowerShell\7\pwsh.exe" /f

:: Disable PowerShell 7 Telemetry
echo Disabling PowerShell 7 telemetry...
reg add "HKLM\SOFTWARE\Microsoft\PowerShell\7" /v "DisableTelemetry" /t REG_DWORD /d 1 /f

:: Set Services to Manual
echo Setting services to manual...
sc config "wuauserv" start= demand
sc config "DiagTrack" start= demand

:: Debloat Microsoft Edge
echo Debloating Microsoft Edge...
taskkill /im msedge.exe /f
reg add "HKCU\Software\Microsoft\Edge" /v "HideFirstRunExperience" /t REG_DWORD /d 1 /f

:: Import Ultimate Power Plan
echo Importing Ultimate Power Plan...
powercfg -import "%~dp0UltimatePowerPlan.pow"

:: Set Ultimate Power Plan
echo Setting Ultimate Power Plan...
powercfg -setactive <UltimatePowerPlan_GUID>

echo Optimization completed!
timeout /t 5

:: Restart Prompt
:restart_prompt
cls
echo =====================================
echo                RESTART
echo =====================================
echo The optimization is complete. You need to restart your PC for all changes to take effect.
echo Do you want to restart now? (Y/N)
set /p restart="Enter choice: "
if /i "%restart%"=="Y" (
    echo Restarting PC...
    shutdown /r /t 0
) else (
    echo Please remember to restart your PC later to apply changes.
)

goto menu

:: Exit the script
:exit_script
echo Exiting...
timeout /t 2
exit
