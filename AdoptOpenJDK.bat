@echo off
setlocal ENABLEDELAYEDEXPANSION
set programFiles=No
set regFiles=No

:verification
DIR "C:\Program Files\Java" | FIND "j"
IF '%ERRORLEVEL%'=='0' (SET programFiles=Yes)
DIR "C:\Program Files (x86)\Java" | FIND "j"
IF '%ERRORLEVEL%'=='0' (SET programFiles=Yes)
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java"
IF '%ERRORLEVEL%'=='0' (set regFiles=Yes)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java"
IF '%ERRORLEVEL%'=='0' (set regFiles=Yes)



IF "%programFiles%"=="Yes" (
  IF "%regFiles%"=="Yes" (
    GOTO :cleanup
  )
) ELSE (GOTO :eof)

:cleanup
ECHO --- Removing commercial Java ---
set x86GUID=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
for /f "tokens=2*" %%A in (
  'reg query "%x86GUID%" /V /F DisplayName /S /E 2^>nul ^| findstr "Java"'
) do (
  for /f "delims=" %%I in ('reg query "%x86GUID%" /s /f "%%B" 2^>nul ^| findstr "HKEY_LOCAL_MACHINE"') do (
    for /f "tokens=2*" %%M in (
      'reg query "%%I" /v "UninstallString" 2^>nul ^|findstr "UninstallString" ^|findstr "MsiExec.exe"'
    ) do (
      SET uninstallStr=%%N
      SET uninstallStr=!uninstallStr:/I=/X!
      ECHO !uninstallStr!
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
      ECHO !uninstallStr!
    )
  )
)

ECHO --- Removing Program Files ---
RMDIR /S /Q "C:\Program Files\Java\jre7"
RMDIR /S /Q "C:\Program Files (x86)\Java\jre7"
RMDIR /S /Q "C:\Program Files\Java\jre6"
RMDIR /S /Q "C:\Program Files (x86)\Java\jre6"

DIR "C:\Program Files\AdoptOpenJDK" | FIND "j"
IF '%ERRORLEVEL%'=='0' (SET adoptjdkFiles=Yes)
DIR "C:\Program Files (x86)\AdoptOpenJDK" | FIND "j"
IF '%ERRORLEVEL%'=='0' (SET adoptjdkFiles=Yes)

IF "%adoptjdkFiles%"=="Yes" (
  GOTO :eof
) ELSE (msiexec /i E:\Downloads\Java\AdoptOpenJDK\OpenJDK8U-jdk_x64_windows_hotspot_8u212b03.msi /quiet /norestart)


:eof
