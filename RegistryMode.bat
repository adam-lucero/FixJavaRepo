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


:: If the latest version is found, remove old JRE and exit script
::
:: Edit this variable for latest version - It's used elsewhere.
set latestJava=Java 8 Update 201
::
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF not errorlevel 1 (
   ECHO Detected latest Java...
   ECHO Removing OLD Java...
   wmic product where "Name like '%%Java(TM) 6%%'" call uninstall /nointeractive
   wmic product where "Name like '%%Java 7%%'" call uninstall /nointeractive
   wmic product where "Name like '%%Java 8 Update 1%%'" call uninstall /nointeractive
   GOTO :eof
)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF not errorlevel 1 (
   ECHO Detected latest Java 2...
   ECHO Removing OLD Java...
   wmic product where "Name like '%%Java(TM) 6%%'" call uninstall /nointeractive
   wmic product where "Name like '%%Java 7%%'" call uninstall /nointeractive
   wmic product where "Name like '%%Java 8 Update 1%%'" call uninstall /nointeractive
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

:: If old JRE detected, install new - CHANGE PATH FOR ***INSTALLATION***
IF "%updateFlag%"=="Yes" (
   ECHO Installing new Java...
   E:\Downloads\Java\jre-8u201-windows-i586.exe /s REMOVEOUTOFDATEJRES=1
)
:: Verify new installation
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF not errorlevel 1 (
   ECHO Installation of new Java complete...
   SET removeOld=Yes
)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF not errorlevel 1 (
   ECHO Installation of new Java complete 2...
   SET removeOld=Yes
)
:: Remove old if new version successfully installed
IF "%removeOld%"=="Yes" (
   ECHO Removing OLD Java 3...
   wmic product where "Name like '%%Java(TM) 6%%'" call uninstall /nointeractive
   wmic product where "Name like '%%Java 7%%'" call uninstall /nointeractive
   wmic product where "Name like '%%Java 8 Update 1%%'" call uninstall /nointeractive
) else (
   ECHO FAILED installation or JDK
   :: Might be able to use GO TO here to loop back to JRE checks
)

:eof