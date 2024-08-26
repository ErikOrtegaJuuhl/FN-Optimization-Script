@echo off
setlocal enabledelayedexpansion

:: Delete temp files
echo Deleting temporary files...
del /s /q "%TEMP%\*"
del /s /q "C:\Windows\Temp\*"

:: Delete Internet Explorer Cache
del /s /q "C:\Users\%USERNAME%\AppData\Local\Microsoft\Windows\INetCache\*"

:: Delete Downloaded Program Files
del /s /q "C:\Windows\Downloaded Program Files\*"

:: Delete Windows Update Files
del /s /q "C:\Windows\SoftwareDistribution\Download\*"

:: Delete Thumbnail Cache
del /s /q "C:\Users\%USERNAME%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_*"

:: Delete Log Files
del /s /q "C:\Windows\System32\winevt\Logs\*"

:: Delete Prefetch Files
del /s /q "C:\Windows\Prefetch\*"

:: Delete Crash Dumps
del /s /q "C:\Windows\Minidump\*"

:: Set Power Plan to High Performance
echo Setting power plan to High Performance...
powercfg /setactive SCHEME_MIN

:: Disable Windows Defender Real-time Monitoring
echo Disabling Windows Defender real-time monitoring...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"

:: Disable Visual Effects (Adjust the settings more thoroughly)
echo Adjusting visual effects for performance...
powershell -Command "$regPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects'; Set-ItemProperty -Path $regPath -Name 'VisualFXSetting' -Value 2"

:: Start an executable (change the path as needed)
echo Starting MSIAfterburner...
start "" "C:\Path\To\MSIAfterburner.exe"

:: Kill unnecessary background processes (update with correct process names)

:: Stop and disable OneDrive
taskkill /f /im OneDrive.exe 2>nul
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDrive /t REG_SZ /d "" /f

:: Stop Windows Search service
net stop "WSearch" 2>nul
sc config "WSearch" start=disabled

:: Stop and disable Windows Update service
net stop "wuauserv" 2>nul
sc config "wuauserv" start=disabled

:: Stop and disable Live Tile updates
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\LiveTile" /v "LiveTile" /t REG_DWORD /d 0 /f

:: Set low priority for specified programs
echo Setting low priority for programs...
set "low_programs=Discord.exe Brave.exe Spotify.exe Steam.exe Epicgames.exe"
set "low_priority=64"

for %%p in (%low_programs%) do (
    echo Setting priority for %%p to Below Normal...
    powershell -Command "Get-Process -Name '%%p' | ForEach-Object { $_.PriorityClass = 'BelowNormal' }"
)

:: Set high priority for specified program
echo Setting high priority for programs...
set "high_programs=fortniteclient-win64-shipping.exe"
set "high_priority=128"

for %%p in (%high_programs%) do (
    echo Setting priority for %%p to Above Normal...
    powershell -Command "Get-Process -Name '%%p' | ForEach-Object { $_.PriorityClass = 'AboveNormal' }"
)

:: Set CPU affinity for a specific process (example: using cores 0-3)
:: Replace 'your_program' with the actual process name
echo Setting CPU affinity for your_program...
powershell -Command "Get-Process -Name 'your_program' | ForEach-Object { $_.ProcessorAffinity = [IntPtr] 15 }"

echo All operations completed.
pause
