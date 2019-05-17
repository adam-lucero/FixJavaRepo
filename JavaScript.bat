@echo off
setlocal ENABLEDELAYEDEXPANSION
set programFiles=No
set regFiles=No

:verify
ECHO --- Starting Verification ---
:: Verify Java is installed
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

:: Don't do anything unless Java 8 Update 201 is installed 
ECHO --- Finding the latest version  ---
DIR "C:\Program Files\Java\jre1.8.0_201\bin\java.exe" 1>nul
IF '%ERRORLEVEL%'=='0' (GOTO :endgame)
DIR "C:\Program Files (x86)\Java\jre1.8.0_201\bin\java.exe" 1>nul
IF '%ERRORLEVEL%'=='0' (GOTO :endgame)
IF "%verifyUpgrade%"=="Yes" (GOTO :eof)
E:\Downloads\Java\JRE\jre-8u201-windows-i586.exe /s REMOVEOUTOFDATEJRES=1
ECHO --- Upgrade Complete ---
SET verifyUpgrade=Yes
GOTO :verify

:: Uninstall everything Java, except JRE 8 Update 201 - x86 and x64
:endgame
ECHO --- Starting The Endgame ---
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
        ) ELSE (
          ECHO Not this one
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
        ) ELSE (
          ECHO Not this one
        )
      )
    )
  )
)
ECHO --- Removing Program Files ---
RMDIR /S /Q "C:\Program Files\Java\jre1.8.0_1"
RMDIR /S /Q "C:\Program Files (x86)\Java\jre1.8.0_1"
RMDIR /S /Q "C:\Program Files\Java\jre1.8.0_0"
RMDIR /S /Q "C:\Program Files (x86)\Java\jre1.8.0_0"
RMDIR /S /Q "C:\Program Files\Java\jre7"
RMDIR /S /Q "C:\Program Files (x86)\Java\jre7"
RMDIR /S /Q "C:\Program Files\Java\jre6"
RMDIR /S /Q "C:\Program Files (x86)\Java\jre6"
RMDIR /S /Q "C:\Program Files\Java\jdk*"
RMDIR /S /Q "C:\Program Files (x86)\Java\jdk*"

:eof
