@echo off

for /f "tokens=3*" %%A in (
  'Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v UninstallString ^| findstr 26A24AE4-039D-4CA4-87B4-2F'
) do (
  ECHO %%A %%B | findstr {26A24AE4-039D-4CA4-87B4-2F32180201F0}
  IF '%ERRORLEVEL%'=='1' (
    SET remediateJRE=Yes
  )
  ECHO %%A %%B | findstr {26A24AE4-039D-4CA4-87B4-2F64180201F0}
  IF '%ERRORLEVEL%'=='1' (
    SET remediateJREx=Yes
  )
  IF "%remediateJRE%"=="Yes" (
   IF "%remediateJREx%"=="Yes" (
      %%A %%B /quiet /norestart
   )
  )
)
)

for /f "tokens=3*" %%A in (
  'Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v UninstallString ^| findstr 26A24AE4-039D-4CA4-87B4-2F'
) do (
  ECHO %%A %%B | findstr {26A24AE4-039D-4CA4-87B4-2F32180201F0}
  IF '%ERRORLEVEL%'=='1' (
    SET remediateJRExx=Yes
  )
  ECHO %%A %%B | findstr {26A24AE4-039D-4CA4-87B4-2F64180201F0}
  IF '%ERRORLEVEL%'=='1' (
    SET remediateJRExxx=Yes
  )
  IF "%remediateJRExx%"=="Yes" (
   IF "%remediateJRExxx%"=="Yes" (
      %%A %%B /quiet /norestart
   )
  )
)
)