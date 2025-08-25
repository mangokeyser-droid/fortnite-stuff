@echo off
setlocal EnableDelayedExpansion
color 0C

set "text1=This BAT is from 2024 and is made by mangokeyser-droid github"
set "text2=It is already done but is being updated soon"
set "text3=I am aiming for another coding language to improve"

call :typeText "!text1!"
call :typeText "!text2!"
call :typeText "!text3!"

timeout /t 2 >nul
cls

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell Start-Process -FilePath "%~f0" -Verb RunAs
    exit /b
)

sc stop OpenVPNService >nul 2>&1
sc stop NordVPNService >nul 2>&1
sc stop ProtonVPNService >nul 2>&1
sc stop WireGuardManager >nul 2>&1
sc stop WindscribeService >nul 2>&1
sc stop SurfsharkService >nul 2>&1
sc stop expressvpn >nul 2>&1
sc stop Viscosity >nul 2>&1

for /f "tokens=*" %%a in ('netsh interface show interface ^| findstr /i "TAP VPN"') do (
    for /f "tokens=1 delims= " %%b in ("%%a") do (
        netsh interface set interface name="%%b" admin=disable
    )
)

echo VPNs turned off You can turn them back on later

del /s /q "%TEMP%\*" >nul 2>&1
del /s /q "%SystemRoot%\Temp\*" >nul 2>&1
echo Y | del /s /q "%SystemDrive%\Users\%USERNAME%\AppData\Local\Temp\*" >nul 2>&1

rmdir /s /q "%localappdata%\EpicGamesLauncher\Saved\webcache" >nul 2>&1
rmdir /s /q "%localappdata%\EpicGamesLauncher\Saved\Logs" >nul 2>&1
rmdir /s /q "%localappdata%\EpicGamesLauncher\Saved\Config" >nul 2>&1
rmdir /s /q "%localappdata%\EpicGamesLauncher\Saved\Crashes" >nul 2>&1

ipconfig /release >nul
ipconfig /flushdns >nul
ipconfig /renew >nul

echo.
set /p scalePrompt=Do you want to open Display Settings to set scale to 100%% Y/N: 
if /I "%scalePrompt%"=="Y" (
    start ms-settings:display
    echo Go to System > Display and set Scale to 100%% manually
)

echo.
echo WARNING This will aggressively clean Fortnite It may log you out and remove traces from the registry

set /p createRestore=Create a system restore point before cleaning Fortnite Y/N: 
if /I "%createRestore%"=="Y" (
    powershell -Command "Checkpoint-Computer -Description 'Before_Fortnite_Clean' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
    if %ERRORLEVEL%==0 (
        echo Restore point created successfully
    ) else (
        echo Failed to create restore point Make sure System Protection is enabled
    )
)

set /p cleanFN=Would you like to aggressively clean Fortnite Y/N: 
if /I "%cleanFN%"=="Y" (
    echo Cleaning Fortnite

    rmdir /s /q "%localappdata%\FortniteGame\Saved\Logs" >nul 2>&1
    rmdir /s /q "%localappdata%\FortniteGame\Saved\Config" >nul 2>&1
    rmdir /s /q "%localappdata%\FortniteGame\Saved\Crashes" >nul 2>&1
    rmdir /s /q "%localappdata%\FortniteGame\Saved\webcache" >nul 2>&1
    del /f /q "%localappdata%\FortniteGame\Saved\*.sav" >nul 2>&1

    reg delete "HKCU\Software\Epic Games" /f >nul 2>&1
    reg delete "HKCU\Software\Fortnite" /f >nul 2>&1
    reg delete "HKLM\Software\Epic Games" /f >nul 2>&1
    reg delete "HKLM\Software\Fortnite" /f >nul 2>&1

    echo Fortnite aggressively cleaned
)

echo.
echo All tasks completed Temp files deleted VPNs off and network refreshed
pause
exit /b

:typeText
set "line=%~1"
set i=0
:loop
set /a i+=1
set "char=!line:~%i%,1!"
if defined char (
    <nul set /p= !char!
    ping -n 1 localhost >nul
    ping -n 1 localhost >nul
    goto loop
) else (
    echo.
    goto :eof
)
