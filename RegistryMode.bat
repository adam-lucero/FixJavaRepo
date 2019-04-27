@ECHO OFF

:: If Java is not installed skip the entire script
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java"
IF not errorlevel 1 (
   ECHO Detected Java...
   SET complete=No
) else (
   SET complete=Yes
)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java"
IF not errorlevel 1 (
   ECHO Detected Java 2...
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


:: Check for the latest version and if found, remove old versions and EOF
:: Edit variable for latest version 
:: HERE
set latestJava=Java 8 Update 201

Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF not errorlevel 1 (
   ECHO Detected latest Java...
   GOTO :eof
)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF not errorlevel 1 (
   ECHO Detected latest Java 2...
   GOTO :eof
)

:: Verify what's installed to BEST action
::
:: Java 8 Family Check
::
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 1"
IF not errorlevel 1 (
   ECHO Detected newest x64 version of Java...
   set updateFlag=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 1"
IF not errorlevel 1 (
   ECHO Detected newest x64 version of Java...
   set updateFlag=Yes
)
::
:: Java 7 Family Check
::
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 7"
IF not errorlevel 1 (
   ECHO Detected newest x64 version of Java...
   set updateFlag=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 7"
IF not errorlevel 1 (
   ECHO Detected newest x64 version of Java...
   set updateFlag=Yes
)
::
:: Java 6 Family Check
::
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java(TM) 6"
IF not errorlevel 1 (
   ECHO Detected newest x64 version of Java...
   set updateFlag=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java(TM) 6"
IF not errorlevel 1 (
   ECHO Detected newest x64 version of Java...
   set updateFlag=Yes
)
::
:: Java Development Kits Check
::
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java SE Development Kit"
IF not errorlevel 1 (
   ECHO Detected JDK
   SET jdkDetection=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java SE Development Kit"
IF not errorlevel 1 (
   ECHO Detected JDK
   SET jdkDetection=Yes
)
::
:: ACTIONS
::
::
:: If old JRE detected, install new, verify new install, then remove old
IF "%updateFlag%"=="Yes" (
   ECHO Installing new Java...
)
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF not errorlevel 1 (
   ECHO Detected latest Java...
   SET removeOld=Yes
)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF not errorlevel 1 (
   ECHO Detected latest Java 2...
   SET removeOld=Yes
)
 
:eof