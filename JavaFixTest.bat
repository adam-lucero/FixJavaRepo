@echo off

for /f "tokens=3*" %%A in (
  'Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v UninstallString ^| findstr 26A24AE4-039D-4CA4-87B4-2F'
) do (
  ECHO %%A %%B
  %%A %%B /quiet /norestart
)
)