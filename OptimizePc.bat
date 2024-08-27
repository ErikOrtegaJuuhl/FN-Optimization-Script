@echo off
setlocal

echo Optimizing PC for gaming...

:: Enable Hardware-Accelerated GPU Scheduling (if supported)
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


echo PC optimization complete!
pause
exit
