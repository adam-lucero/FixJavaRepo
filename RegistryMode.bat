@ECHO OFF


Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java"
IF not errorlevel 1 (
   ECHO Detected x64 Java...
   SET complete=No
) else (
   SET complete=Yes
)

:: Test to see if second reg query gets completed
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java"
IF not errorlevel 1 (
   ECHO Detected x86 Java...
   SET completex=No
) else (
   SET completex=Yes
)

IF "%complete%"=="Yes" (
   IF "%completex%"=="Yes" (
      ECHO FAILED to find Java installed...
      GOTO :eof
   )
)

set latestJava=Java 8 Update 201
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF not errorlevel 1 (
   ECHO Detected newest x64 version of Java...
)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF not errorlevel 1 (
   ECHO Detected newest x86 version of Java...
)

:: STARTING SCRIPT 
ECHO STARTING SCRIPT
 
:eof