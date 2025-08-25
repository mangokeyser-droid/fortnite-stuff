@echo off
setlocal EnableDelayedExpansion
color 0C
title System Maintenance and Fortnite Cleaner

:typeText
setlocal EnableDelayedExpansion
set "line=%~1"
set i=0
:loop
set "char=!line:~%i%,1!"
if defined char (
    <nul set /p= !char!
    timeout /t 0.05 >nul
    set /a i+=1
    goto loop
) else (
    echo.
    endlocal
    goto :eof
)

cls
call :typeText "This BAT is from 2024 and is made by mangokeyser-droid github"
call :typeText "It is already done but is being updated soon"
call :typeText "I am aiming for another coding language to improve"
timeout /t 2 >nul
cls

net session >nul 2>&1
if errorlevel 1 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo Stopping VPN services...
for %%S in (
    OpenVPNService
    NordVPNService
    ProtonVPNService
    WireGuardManager
    WindscribeService
    SurfsharkService
    expressvpn
    Viscosity
) do (
    sc stop %%S >nul 2>&1
)

echo Disabling TAP VPN network interfaces...
for /f "skip=3 tokens=4*" %%a in ('netsh interface show interface ^| findstr /i "TAP VPN"') do (
    netsh interface set interface name="%%b" admin=disable >nul 2>&1
)

echo VPNs turned off. You can turn them back on later.

echo Cleaning temporary files...
del /s /q "%TEMP%\*" >nul 2>&1
del /s /q "%SystemRoot%\Temp\*" >nul 2>&1
echo Y | del /s /q "%SystemDrive%\Users\%USERNAME%\AppData\Local\Temp\*" >nul 2>&1

echo Removing Epic Games Launcher cache...
rmdir /s /q "%localappdata%\EpicGamesLauncher\Saved\webcache" >nul 2>&1
rmdir /s /q "%localappdata%\EpicGamesLauncher\Saved\Logs" >nul 2>&1
rmdir /s /q "%localappdata%\EpicGamesLauncher\Saved\Config" >nul 2>&1
rmdir /s /q "%localappdata%\EpicGamesLauncher\Saved\Crashes" >nul 2>&1

echo Refreshing network configuration...
ipconfig /release >nul
ipconfig /flushdns >nul
ipconfig /renew >nul

echo.
choice /m "Do you want to open Display Settings to set scale to 100%%"
if errorlevel 2 (
    echo Skipping display settings.
) else (
    start ms-settings:display
    echo Please go to System > Display and set Scale to 100%% manually.
)

echo.
echo WARNING: This will aggressively clean Fortnite.
echo It may log you out and remove traces from the registry.

choice /m "Create a system restore point before cleaning Fortnite"
if errorlevel 2 (
    echo Skipping restore point creation.
) else (
    echo Creating system restore point...
    powershell -Command "Checkpoint-Computer -Description 'Before_Fortnite_Clean' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
    if %ERRORLEVEL%==0 (
        echo Restore point created successfully.
    ) else (
        echo Failed to create restore point. Make sure System Protection is enabled.
    )
)

choice /m "Would you like to aggressively clean Fortnite"
if errorlevel 2 (
    echo Skipping Fortnite cleaning.
) else (
    echo Closing Epic Games Launcher to prevent crashes...
    taskkill /f /im EpicGamesLauncher.exe >nul 2>&1
    timeout /t 3 >nul

    echo Cleaning Fortnite files and registry...
    rmdir /s /q "%localappdata%\FortniteGame\Saved\Logs" >nul 2>&1
    rmdir /s /q "%localappdata%\FortniteGame\Saved\Config" >nul 2>&1
    rmdir /s /q "%localappdata%\FortniteGame\Saved\Crashes" >nul 2>&1
    rmdir /s /q "%localappdata%\FortniteGame\Saved\webcache" >nul 2>&1
    del /f /q "%localappdata%\FortniteGame\Saved\*.sav" >nul 2>&1

    reg delete "HKCU\Software\Epic Games" /f >nul 2>&1
    reg delete "HKCU\Software\Fortnite" /f >nul 2>&1
    reg delete "HKLM\Software\Epic Games" /f >nul 2>&1
    reg delete "HKLM\Software\Fortnite" /f >nul 2>&1

    echo Fortnite aggressively cleaned.
)

echo Stopping Fortnite and OneDrive processes...
taskkill /f /im FortniteClient-Win64-Shipping.exe >nul 2>&1
taskkill /f /im OneDrive.exe >nul 2>&1

echo Deleting EasyAntiCheat registry keys...
reg delete "HKLM\SOFTWARE\WOW6432Node\EasyAntiCheat" /f >nul 2>&1
reg delete "HKLM\SYSTEM\ControlSet001\Services\EasyAntiCheat" /f >nul 2>&1
reg delete "HKLM\SYSTEM\ControlSet001\Services\BEService" /f >nul 2>&1

set "USERPROFILE=C:\Users\%USERNAME%"
set "SYSTEMDRIVE=%SYSTEMDRIVE%"

set "foldersToRemove=\
"%USERPROFILE%\AppData\Roaming\Microsoft\Windows\CloudStore" \
"%USERPROFILE%\AppData\Local\FortniteGame\Saved" \
"%USERPROFILE%\AppData\Local\D3DSCache" \
"%USERPROFILE%\AppData\Local\CrashReportClient" \
"%USERPROFILE%\AppData\Local\Microsoft\Windows\SettingSync\metastore" \
"%USERPROFILE%\AppData\Local\Microsoft\Windows\INetCache" \
"%USERPROFILE%\AppData\Local\Microsoft\Windows\INetCookies" \
"%USERPROFILE%\AppData\Local\Microsoft\Windows\History" \
"%USERPROFILE%\AppData\Local\Microsoft\Feeds Cache" \
"%USERPROFILE%\AppData\Local\NVIDIA Corporation" \
"%USERPROFILE%\AppData\Local\AMD\DxCache" \
"%USERPROFILE%\AppData\Local\Microsoft\XboxLive" \
"%USERPROFILE%\AppData\Local\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\AC" \
"%USERPROFILE%\AppData\Local\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\LocalCache" \
"%USERPROFILE%\AppData\Local\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\Settings" \
"%USERPROFILE%\AppData\Local\Packages\Microsoft.Windows.Cortana_cw5n1h2txyewy" \
"%USERPROFILE%\AppData\Local\Microsoft\Windows\WebCache" \
"%USERPROFILE%\AppData\Local\Microsoft\Windows\PowerShell\StartupProfileData-NonInteractive" \
"%USERPROFILE%\AppData\Local\ConnectedDevicesPlatform" \
"%USERPROFILE%\AppData\Local\cache\qtshadercache" \
"%USERPROFILE%\AppData\Local\Microsoft\CLR_v4.0" \
"%USERPROFILE%\AppData\Local\Microsoft\CLR_v3.0" \
"%USERPROFILE%\AppData\Local\EpicGamesLauncher" \
"%USERPROFILE%\AppData\Local\UnrealEngine" \
"%USERPROFILE%\AppData\Local\UnrealEngineLauncher" \
"%USERPROFILE%\AppData\Local\AMD" \
"%USERPROFILE%\AppData\Local\INTEL" \
"%USERPROFILE%\AppData\LocalLow\Microsoft\CryptnetUrlCache" \
"%USERPROFILE%\AppData\Local\Microsoft\Internet Explorer\Recovery" \
"%USERPROFILE%\AppData\Local\Microsoft\Feeds Cache" \
"%USERPROFILE%\AppData\Roaming\EasyAntiCheat" \
"%USERPROFILE%\AppData\Local\Temp" \
"%USERPROFILE%\AppData\Local\Microsoft\Windows\IEDownloadHistory" \
"%USERPROFILE%\AppData\Local\Microsoft\Windows\IECompatUaCache" \
"%USERPROFILE%\AppData\Local\Microsoft\Windows\IECompatCache" \
"%USERPROFILE%\AppData\Local\Microsoft\Windows\INetCookies\DNTException" \
"%USERPROFILE%\AppData\Local\Microsoft\Windows\INetCookies\PrivacIE" \
"%USERPROFILE%\AppData\Local\Microsoft\Windows\History\Low" \
"%USERPROFILE%\AppData\Local\Packages\Microsoft.OneConnect_8wekyb3d8bbwe\LocalState" \
"%USERPROFILE%\AppData\Local\Packages\Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe\LocalCache\EcsCache0" \
"%USERPROFILE%\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\TempState" \
"%USERPROFILE%\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\TargetedContentCache\v3" \
"%USERPROFILE%\Intel" \
"%USERPROFILE%\ntuser.ini" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\LocalLow\Microsoft\CryptnetUrlCache" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Microsoft\Windows\WebCache" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Microsoft\Windows\PowerShell\StartupProfileData-NonInteractive" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\ConnectedDevicesPlatform" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\cache\qtshadercache" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Microsoft\CLR_v4.0" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Microsoft\CLR_v3.0" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Microsoft\Internet Explorer\Recovery" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Microsoft\Feeds Cache" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Roaming\EasyAntiCheat" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Temp" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Microsoft\Windows\IEDownloadHistory" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Microsoft\Windows\IECompatUaCache" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Microsoft\Windows\IECompatCache" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Microsoft\Windows\INetCookies\DNTException" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Microsoft\Windows\INetCookies\PrivacIE" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Microsoft\Windows\History\Low" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Packages\Microsoft.OneConnect_8wekyb3d8bbwe\LocalState" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Packages\Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe\LocalCache\EcsCache0" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\TempState" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\TargetedContentCache\v3" \
"%SYSTEMDRIVE%\Users\%USERNAME%\Intel" \
"%SYSTEMDRIVE%\Users\%USERNAME%\ntuser.ini" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\LocalLow\Microsoft\CryptnetUrlCache" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\Microsoft\Feeds Cache" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\EpicGamesLauncher" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\UnrealEngine" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\UnrealEngineLauncher" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\AMD" \
"%SYSTEMDRIVE%\Users\%USERNAME%\AppData\Local\INTEL" \
"

for %%F in (%foldersToRemove%) do (
    if exist %%F (
        echo Removing folder: %%F
        rmdir /s /q "%%F" >nul 2>&1
    )
)

echo Deleting hidden and system files in Cortana and WebCache folders...
for %%D in (
    "%USERPROFILE%\AppData\Local\Packages\Microsoft.Windows.Cortana_cw5n1h2txyewy\*.*" 
    "%USERPROFILE%\AppData\Local\Microsoft\Windows\WebCache\*.*"
) do (
    attrib -h -s -r "%%D" /s /d >nul 2>&1
    del /f /s /q "%%D" >nul 2>&1
)

echo Deleting additional files...
del /f /s /q "%SYSTEMDRIVE%\ProgramData\Microsoft\DataMart\PaidWiFi\NetworksCache" >nul 2>&1
del /f /s /q "%SYSTEMDRIVE%\ProgramData\Microsoft\DataMart\PaidWiFi\Rules" >nul 2>&1
del /f /s /q "%SYSTEMDRIVE%\ProgramData\Microsoft\Windows\WER" >nul 2>&1
del /f /s /q "%SYSTEMDRIVE%\Users\Public\Libraries" >nul 2>&1
del /f /s /q "%SYSTEMDRIVE%\MSOCache" >nul 2>&1

echo Cleaning recycle bins...
rd /s /q "%SYSTEMDRIVE%\$Recycle.Bin" >nul 2>&1
for %%D in (D: E: F:) do (
    if exist %%D\$Recycle.Bin (
        rd /s /q "%%D\$Recycle.Bin" >nul 2>&1
    )
)

echo.
echo All tasks completed: Temp files deleted, VPNs off, Fortnite cleaned, and system traces removed.
pause
exit /b
