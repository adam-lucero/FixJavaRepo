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
set latestJava=Java 8 Update 201

Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF not errorlevel 1 (
   ECHO Detected latest Java...
   ECHO Removing OLD Java...
   ECHO Uninstall 8...
   ECHO Uninstall 7...
   ECHO Uninstall 6...
   GOTO :eof
)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF not errorlevel 1 (
   ECHO Detected latest Java 2...
   ECHO Removing OLD Java...
   ECHO Uninstall 8...
   ECHO Uninstall 7...
   ECHO Uninstall 6...
   GOTO :eof
)

::
:: JRE CHECKS
::

:: Java 8 Family Check
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 1"
IF not errorlevel 1 (
   ECHO Detected Java 8 Family...
   set updateFlag=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 1"
IF not errorlevel 1 (
   ECHO Detected Java 8 Family 2...
   set updateFlag=Yes
)
:: Java 7 Family Check
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 7"
IF not errorlevel 1 (
   ECHO Detected Java 7 Family...
   set updateFlag=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 7"
IF not errorlevel 1 (
   ECHO Detected Java 7 Family 2...
   set updateFlag=Yes
)
:: Java 6 Family Check
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java(TM) 6"
IF not errorlevel 1 (
   ECHO Detected Java 6 Family...
   set updateFlag=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java(TM) 6"
IF not errorlevel 1 (
   ECHO Detected Java 6 Family 2...
   set updateFlag=Yes
)

::
:: JRE ACTION
::

:: If old JRE detected, install new
IF "%updateFlag%"=="Yes" (
   ECHO Installing new Java...
)
:: Verify new installation
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF not errorlevel 1 (
   ECHO Installation of new Java complete...
   SET removeOld=Yes
)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF not errorlevel 1 (
   ECHO Installation of new Java complete...
   SET removeOld=Yes
)
:: Remove old if new version successfully installed
IF "%removeOld%"=="Yes" (
   ECHO Removing OLD Java...
   ECHO Uninstall 8...
   ECHO Uninstall 7...
   ECHO Uninstall 6...
) else (
   ECHO FAILED REMEDIATION
)

:eof