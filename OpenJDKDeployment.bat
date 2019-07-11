@ECHO off
SETLOCAL ENABLEDELAYEDEXPANSION
SET loggingVar=###################

:::::::::::::::::::::::::
::  OpenJDKDeployment  ::
:::::::::::::::::::::::::

::  Author: @dam Lucer0


:: MUST disable UAC on target devices before running script (registry key available)
:: If Java is installed, script will silently remove all versions of Oracle Java (JDK & JRE) and then install AdoptOpenJDK
:: AdoptOpenJDK adds to PATH variable during installation

:: CHANGE INSTALLATION PATH HERE !!! 
SET installationPath=E:\Downloads\Java\AdoptOpenJDK\OpenJDK8U-jre_x86-32_windows_hotspot_8u212b04.msi


SET installedJava=C:\Windows\Temp\OpenJDKMigration.txt
DEL /F /Q %installedJava% 2>nul
TIME /T >> %installedJava%
DATE /T >> %installedJava% 
ECHO %loggingVar% Before Changes %loggingVar% >> %installedJava%
SET PATH >> %installedJava%


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
    DIR "!directory!" >> %installedJava%
)
FOR /D %%C IN ("C:\Program Files (x86)\Java\*") DO (
    SET directory=%%C
    DIR "!directory!" >> %installedJava%
)
FIND "C:\Program Files\Java\j" %installedJava% >> %installedJava%
IF '%ERRORLEVEL%'=='0' (SET programFiles=Yes)
FIND "C:\Program Files (x86)\Java\j" %installedJava% >> %installedJava%
IF '%ERRORLEVEL%'=='0' (SET programFiles=Yes )
IF "%programFiles%"=="No" (
  ECHO %loggingVar% ENDING: No Program File Matches %loggingVar% >> %installedJava%
  GOTO :eof
)


ECHO --- Java Detected ---
SET x64GUID=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
FOR /f "tokens=2*" %%A in (
  'REG query "%x64GUID%" /V /F DisplayName /S /E 2^>nul ^| FIND "Java"'
) do (
  FOR /f "delims=" %%I in ('REG query "%x64GUID%" /s /f "%%B" 2^>nul ^| FINDSTR "HKEY_LOCAL_MACHINE"') do (
    FOR /f "tokens=2*" %%M in (
      'REG query "%%I" /v "UninstallString" 2^>nul ^|FINDSTR "UninstallString" ^|FINDSTR "MsiExec.exe"'
    ) do (
      SET uninstallStr=%%N
      SET uninstallStr=!uninstallStr:/I=/X!
      !uninstallStr! /quiet /norestart
    )
  )
)
SET x86GUID=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
FOR /f "tokens=2*" %%A in (
  'REG query "%x86GUID%" /V /F DisplayName /S /E 2^>nul ^| FIND "Java"'
) do (
  FOR /f "delims=" %%I in ('REG query "%x86GUID%" /s /f "%%B" 2^>nul ^| FINDSTR "HKEY_LOCAL_MACHINE"') do (
    FOR /f "tokens=2*" %%M in (
      'REG query "%%I" /v "UninstallString" 2^>nul ^|FINDSTR "UninstallString" ^|FINDSTR "MsiExec.exe"'
    ) do (
      SET uninstallStr=%%N
      SET uninstallStr=!uninstallStr:/I=/X!
      !uninstallStr! /quiet /norestart
    )
  )
)
RMDIR /S /Q "C:\Program Files\Java\" 2>nul
RMDIR /S /Q "C:\Program Files (x86)\Java\" 2>nul


ECHO %loggingVar% After Changes %loggingVar% >> %installedJava% 
SET PATH >> %installedJava%
REG Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2>nul | FIND "Java" >> %installedJava%
REG Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName 2>nul | FIND "Java" >> %installedJava%
FOR /D %%C IN ("C:\Program Files\Java\*") DO (
    SET directory=%%C
    DIR "!directory!" >> %installedJava%
)
FOR /D %%C IN ("C:\Program Files (x86)\Java\*") DO (
    SET directory=%%C
    DIR "!directory!" >> %installedJava%
)


:verifyUpgrade
ECHO %loggingVar% AdoptOpenJDK Installations %loggingVar% >> %installedJava%
DIR "C:\Program Files\AdoptOpenJDK\" 2>nul | FIND /I "j" >> %installedJava%
IF '%ERRORLEVEL%'=='0' (SET adoptjdkFiles=Yes)
DIR "C:\Program Files (x86)\AdoptOpenJDK\" 2>nul | FIND /I "j" >> %installedJava%
IF '%ERRORLEVEL%'=='0' (SET adoptjdkFiles=Yes)

IF "%adoptjdkFiles%"=="Yes" (
  IF "%verifyUpgrade%"=="Yes" (
    ECHO --- ENDING: Installation Successful ---
    GOTO :eof
  )
  ECHO --- ENDING: AdoptOpenJDK Already Installed ---
  GOTO :eof
)
IF "%verifyUpgrade%"=="Yes" (
  ECHO --- ENDING: Installation Failure ---
  GOTO :eof
)

ECHO --- Installing OpenJDK ---
msiexec /i %installationPath% /quiet /norestart

ECHO --- Verifying Installation ---
SET verifyUpgrade=Yes
GOTO :verifyUpgrade

:eof
