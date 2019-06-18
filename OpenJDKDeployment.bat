@echo off
setlocal ENABLEDELAYEDEXPANSION

:::::::::::::::::::::::::
::  OpenJDKDeployment  ::
:::::::::::::::::::::::::

::  Author: @dam Lucer0

:: Important ::
:: All target devices must have UAC Disabled before running (registry key)
:: If Java is installed, script will silently remove all versions of Oracle Java (JDK & JRE) and then install AdoptOpenJDK

:: CHANGE INSTALLATION PATH !!! 
SET installationPath=\\Domain\NETLOGON\AdoptJDK.exe


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


ECHO --- Removing Oracle Java Installations ---
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


ECHO --- Removing Old Program Files ---
RMDIR /S /Q "C:\Program Files\Java\"
RMDIR /S /Q "C:\Program Files (x86)\Java\"


ECHO --- Installing OpenJDK ---
DIR "C:\Program Files\AdoptOpenJDK" | FIND "j"
IF '%ERRORLEVEL%'=='0' (SET adoptjdkFiles=Yes)
DIR "C:\Program Files (x86)\AdoptOpenJDK" | FIND "j"
IF '%ERRORLEVEL%'=='0' (SET adoptjdkFiles=Yes)

IF "%adoptjdkFiles%"=="Yes" (
  GOTO :eof
) ELSE (msiexec /i %installationPath% /quiet /norestart)

:eof
