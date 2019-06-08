@echo off
setlocal ENABLEDELAYEDEXPANSION

:::::::::::::::::::::::::
::  OpenJDK Migration  ::
:::::::::::::::::::::::::

::  Author: @dam Lucer0

:: Informational ::
:: 1. Make sure all target devices have UAC Disabled before running (can be done with reg key)
:: 2. Change the INSTALLATION PATH below!


:: Verify Java is installed
set programFiles=No
set regFiles=No
ECHO --- Starting Verification ---
DIR "C:\Program Files\Java" | FIND "j"
IF '%ERRORLEVEL%'=='0' (SET programFiles=Yes)
DIR "C:\Program Files (x86)\Java" | FIND "j"
IF '%ERRORLEVEL%'=='0' (SET programFiles=Yes)
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java"
IF '%ERRORLEVEL%'=='0' (set regFiles=Yes)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java"
IF '%ERRORLEVEL%'=='0' (set regFiles=Yes)
:: 
IF "%programFiles%"=="No" (GOTO :eof)
IF "%regFiles%"=="No" (GOTO :eof)

:: Remove all versions of commercial Java
ECHO --- Removing commercial Java ---
set x64GUID=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
for /f "tokens=2*" %%A in (
  'reg query "%x64GUID%" /V /F DisplayName /S /E 2^>nul ^| findstr "Java"'
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
  'reg query "%x86GUID%" /V /F DisplayName /S /E 2^>nul ^| findstr "Java"'
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
:: Delete Program File remnants
ECHO --- Removing Program Files ---
RMDIR /S /Q "C:\Program Files\Java\"
RMDIR /S /Q "C:\Program Files (x86)\Java\"

:: Install OpenJDK
DIR "C:\Program Files\AdoptOpenJDK" | FIND "j"
IF '%ERRORLEVEL%'=='0' (SET adoptjdkFiles=Yes)
DIR "C:\Program Files (x86)\AdoptOpenJDK" | FIND "j"
IF '%ERRORLEVEL%'=='0' (SET adoptjdkFiles=Yes)

IF "%adoptjdkFiles%"=="Yes" (
  GOTO :eof
) ELSE (msiexec /i E:\Downloads\Java\AdoptOpenJDK\OpenJDK8U-jdk_x64_windows_hotspot_8u212b03.msi /quiet /norestart)


:eof
