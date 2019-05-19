::::::::::::::::::
::  JavaScript  ::
::::::::::::::::::

::  Author: @dam Lucer0

:: Instructions 
:: 1. Make sure all devices have UAC Disabled (can be done with reg key)
:: 2. Change the INSTALLATION PATH below!


@echo off
setlocal ENABLEDELAYEDEXPANSION
set programFiles=No
set regFiles=No

:: Verify Java is installed
:verify
ECHO --- Starting Verification ---
DIR "C:\Program Files\Java" | FIND "j"
IF '%ERRORLEVEL%'=='0' (SET programFiles=Yes)
DIR "C:\Program Files (x86)\Java" | FIND "j"
IF '%ERRORLEVEL%'=='0' (SET programFiles=Yes)
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java"
IF '%ERRORLEVEL%'=='0' (set regFiles=Yes)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java"
IF '%ERRORLEVEL%'=='0' (set regFiles=Yes)
IF "%programFiles%"=="No" (GOTO :eof)
IF "%regFiles%"=="No" (GOTO :eof)

:: Make sure Java 8 Update 201 is installed before continuing 
ECHO --- Finding the latest version  ---
DIR "C:\Program Files\Java\jre1.8.0_201\bin\java.exe" 1>nul
IF '%ERRORLEVEL%'=='0' (GOTO :cleanup)
DIR "C:\Program Files (x86)\Java\jre1.8.0_201\bin\java.exe" 1>nul
IF '%ERRORLEVEL%'=='0' (GOTO :cleanup)
IF "%verifyUpgrade%"=="Yes" (GOTO :eof)

:: CHANGE INSTALLATION PATH HERE !!!
E:\Downloads\Java\JRE\jre-8u201-windows-i586.exe /s REMOVEOUTOFDATEJRES=1
::
ECHO --- Upgrade Complete ---
ECHO --- Verifying Successful Upgrade ---
SET verifyUpgrade=Yes
GOTO :verify

:: Uninstall everything Java, except JRE 8 Update 201 - x86 and x64
:cleanup
ECHO --- Starting The Cleanup ---
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
      IF NOT "!uninstallStr!"=="MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F32180201F0}" (
        IF NOT "!uninstallStr!"=="MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F64180201F0}" (
          !uninstallStr! /quiet /norestart
        )
      )
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
      IF NOT "!uninstallStr!"=="MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F32180201F0}" (
        IF NOT "!uninstallStr!"=="MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F64180201F0}" (
          !uninstallStr! /quiet /norestart
        )
      )
    )
  )
)
ECHO --- Removing Program Files ---
FOR /D %%C IN (
    "C:\Program Files\Java\*"
) DO (
    SET directory=%%C
    IF NOT "!directory!"=="C:\Program Files\Java\jre1.8.0_201" (
        RMDIR /S /Q "!directory!"
    )
)
FOR /D %%C IN (
    "C:\Program Files (x86)\Java\*"
) DO (
    SET directory=%%C
    IF NOT "!directory!"=="C:\Program Files (x86)\Java\jre1.8.0_201" (
        RMDIR /S /Q "!directory!"
    )
)

:eof
