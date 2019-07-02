@ECHO off
SETLOCAL ENABLEDELAYEDEXPANSION
SET loggingVar=###################

::::::::::::::::::::::::::::
::  OracleJavaRemediation ::
::::::::::::::::::::::::::::

::  Author: @dam Lucer0


:: MUST disable UAC on target devices before running script (registry key available)
:: If Java is installed, script will silently upgrade to the latest version and remove all old versions (JDK and JRE) 

:: Where is the installation media? 
SET installationPath=E:\Downloads\Java\JRE\jre-8u201-windows-i586.exe
:: What is the current version of Java? 
SET currentVersion=Java 8 Update 201
:: What are the 32 and 64 bit Uninstallstrings for the current version
SET uninstallString=MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F32180201F0}
SET uninstallStringSixFour=MsiExec.exe /X{26A24AE4-039D-4CA4-87B4-2F64180201F0}
:: What is the installation directory for the current version
SET installDirectory=C:\Program Files (x86)\Java\jre1.8.0_201
SET installDirectorySixFour=C:\Program Files\Java\jre1.8.0_201



SET installedJava=C:\Windows\Temp\InstalledJava.txt
DEL /F /Q %installedJava% 2>nul
TIME /T >> %installedJava%
DATE /T >> %installedJava% 
ECHO %loggingVar% Before Changes %loggingVar% >> %installedJava%


:verify
ECHO %loggingVar% Registry Keys %loggingVar% >> %installedJava%
SET regFiles=No
REG Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2>nul | FIND "Java" >> %installedJava%
IF '%ERRORLEVEL%'=='0' (SET regFiles=Yes)
REG Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2>nul | FIND "Java" >> %installedJava%
IF '%ERRORLEVEL%'=='0' (SET regFiles=Yes)
IF "%regFiles%"=="No" (
  ECHO %loggingVar% ENDING: No Registry Key Matches %loggingVar% >> %installedJava%
  GOTO :eof
)
ECHO %loggingVar% Program Files %loggingVar% >> %installedJava%
SET programFiles=No
FOR /D %%C IN ("C:\Program Files\Java\*") DO (
    SET directory=%%C
    ECHO !directory! >> %installedJava%
    DIR "!directory!" >> %installedJava%
)
FOR /D %%C IN ("C:\Program Files (x86)\Java\*") DO (
    SET directory=%%C
    ECHO !directory! >> %installedJava%
    DIR "!directory!" >> %installedJava%
)
IF "%cleanupComplete%"=="Yes" (
  ECHO --- ENDING: Script Success ---
  GOTO :eof
)
FIND "C:\Program Files\Java\j" %installedJava% >> %installedJava%
IF '%ERRORLEVEL%'=='0' (SET programFiles=Yes)
FIND "C:\Program Files (x86)\Java\j" %installedJava% >> %installedJava%
IF '%ERRORLEVEL%'=='0' (SET programFiles=Yes )
IF "%programFiles%"=="No" (
  ECHO %loggingVar% ENDING: No Program File Matches %loggingVar% >> %installedJava%
  GOTO :eof
)


FIND "%currentVersion%" %installedJava% >> %installedJava%
IF '%ERRORLEVEL%'=='0' (
    ECHO --- Current Version Detected ---
    GOTO :cleanup
)
IF "%verifyUpgrade%"=="Yes" (
    ECHO --- ENDING: Upgrade Failure ---
    GOTO :eof
)


ECHO --- Upgrading ---
%installationPath% /s REMOVEOUTOFDATEJRES=1
ECHO --- Verifying Upgrade ---
ECHO %loggingVar% After Upgrade %loggingVar% >> %installedJava%
SET verifyUpgrade=Yes
GOTO :verify


:cleanup
ECHO --- Removing Old Versions ---
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
      IF NOT "!uninstallStr!"=="%uninstallString%" (
        IF NOT "!uninstallStr!"=="%uninstallStringSixFour%" (
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
      IF NOT "!uninstallStr!"=="%uninstallString%" (
        IF NOT "!uninstallStr!"=="%uninstallStringSixFour%" (
          !uninstallStr! /quiet /norestart
        )
      )
    )
  )
)
FOR /D %%C IN (
    "C:\Program Files (x86)\Java\*"
) DO (
    SET directory=%%C
    IF NOT "!directory!"=="%installDirectory%" (
        RMDIR /S /Q "!directory!"
    )
)
FOR /D %%C IN (
    "C:\Program Files\Java\*"
) DO (
    SET directory=%%C
    IF NOT "!directory!"=="%installDirectorySixFour%" (
        RMDIR /S /Q "!directory!"
    )
)
SET cleanupComplete=Yes
ECHO %loggingVar% After Cleanup %loggingVar% >> %installedJava%
GOTO :verify

:eof
