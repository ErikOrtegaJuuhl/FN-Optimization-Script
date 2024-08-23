@echo off
:: Enhanced Batch Script with a Professional Menu for System Tweaks

:: Ensure the script is run as an administrator
:check_admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script requires Administrator privileges. Please run it as an Administrator.
    pause
    exit /b
)

:restore_point_menu
cls
echo ==========================================================
echo                Ortify's SYSTEM TWEAK UTILITY
echo
echo            Do you want to create a restore point?
echo ==========================================================
echo 1. Yes, create a restore point now
echo 2. No, skip to the main menu
echo ==========================================================
set /p choice="Enter your choice (1-2): "

if "%choice%"=="1" goto :create_restore_point
if "%choice%"=="2" goto :main_menu
goto :restore_point_menu

:create_restore_point
cls
echo ==========================================================
echo                Ortify's SYSTEM TWEAK UTILITY
echo
echo            Creating a System Restore Point...
echo ==========================================================


:: Set a variable for the restore point name
set rpName="Before Ortify Tweaking Pack"

:: Create a system restore point
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint %rpName%, 100, 7

:: Check if the restore point creation was successful
if %errorLevel% == 0 (
    echo Restore point created successfully.
) else (
    echo Failed to create restore point.
)
pause
goto :main_menu

:main_menu
cls
echo ==========================================================
echo                Ortify's SYSTEM TWEAK UTILITY
echo
echo                         MAIN MENU
echo ==========================================================
echo 1. How to Run Tweaks
echo 2. Settings Tweaks
echo 3. Power Tweaks
echo 4. Regedit Tweaks
echo 5. Network Tweaks
echo 6. Enable All Tweaks
echo 7. Back to Restore Point Menu
echo 8. Exit
echo ==========================================================
set /p choice="Enter your choice (1-8): "

if "%choice%"=="1" goto :menu_how_to
if "%choice%"=="2" goto :menu_settings_tweaks
if "%choice%"=="3" goto :menu_power_tweaks
if "%choice%"=="4" goto :menu_regedit_tweaks
if "%choice%"=="5" goto :menu_network_tweaks
if "%choice%"=="6" goto :enable_all_tweaks
if "%choice%"=="7" goto :restore_point_menu
if "%choice%"=="8" goto :exit
goto :main_menu

:menu_how_to
cls
echo ==========================================================
echo                Ortify's SYSTEM TWEAK UTILITY
echo
echo                    HOW TO RUN TWEAKS
echo ==========================================================
echo To run all tweaks, you need to install PowerRun and run this script with it.
echo 1. Install PowerRun (Redirect to Website)
echo 2. Back to Main Menu
echo ==========================================================
set /p choice="Enter your choice (1-2): "

if "%choice%"=="1" goto :install_power_run
if "%choice%"=="2" goto :main_menu
goto :menu_how_to

:install_power_run
cls
echo Redirecting to the PowerRun download page...
start https://www.sordum.org/9416/power-run-v1-4-run-with-highest-privileges/
pause
goto :menu_how_to

:menu_settings_tweaks
cls
echo ==========================================================
echo                Ortify's SYSTEM TWEAK UTILITY
echo
echo                    SETTINGS TWEAKS
echo ==========================================================
echo 1. Delete Temporary Files
echo 2. Disable Windows Defender
echo 3. Enable High Performance Power Plan
echo 4. Disable Xbox Game Bar
echo 5. Enable Game Mode
echo 6. Back to Main Menu
echo ==========================================================
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto :delete_temp_files
if "%choice%"=="2" goto :disable_windows_defender
if "%choice%"=="3" goto :enable_high_performance
if "%choice%"=="4" goto :disable_xbox_game_bar
if "%choice%"=="5" goto :enable_game_mode
if "%choice%"=="6" goto :main_menu
goto :menu_settings_tweaks

:delete_temp_files
cls
echo ==========================================================
echo                Ortify's SYSTEM TWEAK UTILITY
echo
echo                Deleting Temporary Files...
echo ==========================================================
rd /s /q "%temp%"
md "%temp%"
rd /s /q "C:\Windows\Temp"
md "C:\Windows\Temp"
echo Temporary files deleted successfully.
pause
goto :menu_settings_tweaks

:disable_windows_defender
cls
echo ==========================================================
echo                Ortify's SYSTEM TWEAK UTILITY
echo
echo                Disabling Windows Defender...
echo ==========================================================
PowerShell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
echo Windows Defender real-time protection disabled.
pause
goto :menu_settings_tweaks

:enable_high_performance
cls
echo ==========================================================
echo                Ortify's SYSTEM TWEAK UTILITY
echo
echo            Enabling High Performance Power Plan...
echo ==========================================================
powercfg -setactive SCHEME_MIN
echo High Performance Power Plan enabled.
pause
goto :menu_power_tweaks

:disable_xbox_game_bar
cls
echo ==========================================================
echo                Ortify's SYSTEM TWEAK UTILITY
echo
echo                Disabling Xbox Game Bar...
echo ==========================================================
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
echo Xbox Game Bar disabled.
pause
goto :menu_settings_tweaks

:enable_game_mode
cls
echo ==========================================================
echo                Ortify's SYSTEM TWEAK UTILITY
echo
echo                  Enabling Game Mode...
echo ==========================================================
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f
echo Game Mode has been enabled.
pause
goto :menu_settings_tweaks

:menu_power_tweaks
cls
echo ==========================================================
echo                Ortify's SYSTEM TWEAK UTILITY
echo
echo                     POWER TWEAKS
echo ==========================================================
echo 1. Enable High Performance Power Plan
echo 2. Back to Main Menu
echo ==========================================================
set /p choice="Enter your choice (1-2): "

if "%choice%"=="1" goto :enable_high_performance
if "%choice%"=="2" goto :main_menu
goto :menu_power_tweaks

:menu_regedit_tweaks
cls
echo ==========================================================
echo                Ortify's SYSTEM TWEAK UTILITY
echo
echo                    REGEDIT TWEAKS
echo ==========================================================
:: Add your regedit tweaks here
pause
goto :main_menu

:menu_network_tweaks
cls
echo ==========================================================
echo                Ortify's SYSTEM TWEAK UTILITY
echo
echo                    NETWORK TWEAKS
echo ==========================================================
:: Add your network tweaks here
pause
goto :main_menu

:enable_all_tweaks
cls
echo ==========================================================
echo                Ortify's SYSTEM TWEAK UTILITY
echo
echo                  Enabling All Tweaks...
echo ==========================================================
:: Call individual tweak functions here
call :delete_temp_files
call :disable_windows_defender
call :enable_high_performance
call :disable_xbox_game_bar
call :enable_game_mode
echo All tweaks have been applied.
pause
goto :main_menu

:exit
cls
echo ==========================================================
echo                Ortify's SYSTEM TWEAK UTILITY
echo
echo                       Exiting...
echo ==========================================================
exit
