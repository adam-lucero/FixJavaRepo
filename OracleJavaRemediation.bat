@echo off
setlocal ENABLEDELAYEDEXPANSION

::::::::::::::::::::::::::::
::  OracleJavaRemediation ::
::::::::::::::::::::::::::::

::  Author: @dam Lucer0

:: Important ::
:: All target devices must have UAC Disabled before running (registry key)
:: If Java is installed, script will silently upgrade to the latest version and remove all old versions (JDK and JRE) 

:: CHANGE INSTALLATION PATH !!! 
SET installationPath=\\Domain\NETLOGON\JRE8U201.exe

:: Silent and remove old installations (DEFAULT)
SET switches=/s REMOVEOUTOFDATEJRES=1

:verify
ECHO --- Finding Java Installations ---
set programFiles=No
set regFiles=No
DIR "C:\Program Files\Java" 2>nul | FIND "j"
IF '%ERRORLEVEL%'=='0' (SET programFiles=Yes)
DIR "C:\Program Files (x86)\Java" 2>nul | FIND "j"
IF '%ERRORLEVEL%'=='0' (SET programFiles=Yes)
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2>nul | find "Java"
IF '%ERRORLEVEL%'=='0' (set regFiles=Yes)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2>nul | find "Java"
IF '%ERRORLEVEL%'=='0' (set regFiles=Yes)
::
IF "%programFiles%"=="No" (GOTO :eof)
IF "%regFiles%"=="No" (GOTO :eof)


ECHO --- Verifying Java Version ---
DIR "C:\Program Files\Java\jre1.8.0_201\bin\java.exe" 1>nul
IF '%ERRORLEVEL%'=='0' (GOTO :cleanup)
DIR "C:\Program Files (x86)\Java\jre1.8.0_201\bin\java.exe" 1>nul
IF '%ERRORLEVEL%'=='0' (GOTO :cleanup)
IF "%verifyUpgrade%"=="Yes" (GOTO :eof)


ECHO --- Upgrading Java ---
%installationPath% %switches%
ECHO --- Verifying Upgrade ---
SET verifyUpgrade=Yes
GOTO :verify

:: Uninstall everything except JRE 8 Update 201 - x86 and x64
:cleanup
ECHO --- Removing Old Java Versions ---
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
ECHO --- Removing Old Program Files ---
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
