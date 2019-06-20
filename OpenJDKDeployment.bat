@echo off
setlocal ENABLEDELAYEDEXPANSION

:::::::::::::::::::::::::
::  OpenJDKDeployment  ::
:::::::::::::::::::::::::

::  Author: @dam Lucer0

:: Important ::
:: All target devices must have UAC Disabled before running (registry key)
:: If Java is installed, script will silently remove all versions of Oracle Java (JDK & JRE) and then install AdoptOpenJDK
:: AdoptOpenJDK adds to PATH variable during installation

:: CHANGE INSTALLATION PATH !!! 
SET installationPath=E:\Downloads\Java\AdoptOpenJDK\OpenJDK8U-jre_x86-32_windows_hotspot_8u212b04.msi


SET installedJava=C:\Windows\Temp\InstalledJava.txt
ECHO --- Begin Log --- >> %installedJava%
TIME /T >> %installedJava%
DATE /T >> %installedJava%
ECHO PATH Environment Variables: >> %installedJava%
SET PATH >> %installedJava%

ECHO --- Java Registry Keys  --- >> %installedJava%
set regFiles=No
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2>nul | find "Java" >> %installedJava%
IF '%ERRORLEVEL%'=='0' (set regFiles=Yes)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2>nul | find "Java" >> %installedJava%
IF '%ERRORLEVEL%'=='0' (set regFiles=Yes)
IF "%regFiles%"=="No" (GOTO :eof)

ECHO --- Java Program Files --- >> %installedJava%
set programFiles=No
FOR /D %%C IN ("C:\Program Files\Java\*") DO (
    SET directory=%%C
    DIR "!directory!" >> %installedJava%
)
FOR /D %%C IN ("C:\Program Files (x86)\Java\*") DO (
    SET directory=%%C
    DIR "!directory!" >> %installedJava%
)
Find "C:\Program Files\Java\j" %installedJava% >> %installedJava%
IF '%ERRORLEVEL%'=='0' (SET programFiles=Yes)
Find "C:\Program Files (x86)\Java\j" %installedJava% >> %installedJava%
IF '%ERRORLEVEL%'=='0' (SET programFiles=Yes )
IF "%programFiles%"=="No" (GOTO :eof)
ECHO --- Java Detected ---


ECHO --- Uninstalling ---
set x64GUID=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
for /f "tokens=2*" %%A in (
  'reg query "%x64GUID%" /V /F DisplayName /S /E 2^>nul ^| find "Java"'
) do (
  for /f "delims=" %%I in ('reg query "%x64GUID%" /s /f "%%B" 2^>nul ^| findstr "HKEY_LOCAL_MACHINE"') do (
    for /f "tokens=2*" %%M in (
      'reg query "%%I" /v "UninstallString" 2^>nul ^|findstr "UninstallString" ^|findstr "MsiExec.exe"'
    ) do (
      SET uninstallStr=%%N
      SET uninstallStr=!uninstallStr:/I=/X!
      !uninstallStr! /quiet /norestart
    )
  )
)
set x86GUID=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
for /f "tokens=2*" %%A in (
  'reg query "%x86GUID%" /V /F DisplayName /S /E 2^>nul ^| find "Java"'
) do (
  for /f "delims=" %%I in ('reg query "%x86GUID%" /s /f "%%B" 2^>nul ^| findstr "HKEY_LOCAL_MACHINE"') do (
    for /f "tokens=2*" %%M in (
      'reg query "%%I" /v "UninstallString" 2^>nul ^|findstr "UninstallString" ^|findstr "MsiExec.exe"'
    ) do (
      SET uninstallStr=%%N
      SET uninstallStr=!uninstallStr:/I=/X!
      !uninstallStr! /quiet /norestart
    )
  )
)
RMDIR /S /Q "C:\Program Files\Java\" 2>nul
RMDIR /S /Q "C:\Program Files (x86)\Java\" 2>nul


:verifyUpgrade
ECHO --- AdoptOpenJDK Installations --- >> %installedJava%
DIR "C:\Program Files\AdoptOpenJDK" 2>nul | FIND /I "j" >> %installedJava%
IF '%ERRORLEVEL%'=='0' (SET adoptjdkFiles=Yes)
DIR "C:\Program Files (x86)\AdoptOpenJDK" 2>nul | FIND /I "j" >> %installedJava%
IF '%ERRORLEVEL%'=='0' (SET adoptjdkFiles=Yes)

IF "%adoptjdkFiles%"=="Yes" (
  IF "%verifyUpgrade%"=="Yes" (
    ECHO --- AdoptOpenJDK Installation Successful ---
    GOTO :eof
  )
  GOTO :eof
)
IF "%verifyUpgrade%"=="Yes" (
  ECHO --- AdoptOpenJDK Installation Failure ---
  ECHO --- AdoptOpenJDK Installation Failure --- >> %installedJava%
  SET PATH >> %installedJava%
  GOTO :eof
)

ECHO --- Installing AdoptOpenJDK ---
msiexec /i %installationPath% /quiet /norestart

ECHO --- Verifying OpenJDK Installation ---
SET verifyUpgrade=Yes
GOTO :verifyUpgrade

:eof
