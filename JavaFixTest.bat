@echo off
setlocal ENABLEDELAYEDEXPANSION

for /f "tokens=3*" %%A in (
  'Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName ^| findstr Java'
) do (
  ECHO %%A %%B
 )