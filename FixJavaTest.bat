:: Author - Adam Lucero
:: 04/2019
:: Java Remediation Tool
:: If Java is not installed, don't do anything
:: If Java is installed, upgrade, and remove old versions
:: Disable UAC before Running!
@ECHO OFF


:: Edit this variable for latest version - It's used elsewhere.
set latestJava=Java 8 Update 201


::
:: JRE CHECKS
::

:: Check Program Files
DIR "C:\Program Files\Java" | FIND "jre"
IF '%ERRORLEVEL%'=='0' (
    ECHO File Path JRE---
    SET complete=No
    SET jreFiles=Yes
)
DIR "C:\Program Files (x86)\Java" | FIND "jre"
IF '%ERRORLEVEL%'=='0' (
    ECHO File Path JRE 2---
    SET complete=No
    SET jreFiles=Yes
)
DIR "C:\Program Files\Java" | FIND "jdk"
IF '%ERRORLEVEL%'=='0' (
    ECHO File Path JDK---
    SET complete=No
    SET jdkFiles=Yes
)
DIR "C:\Program Files (x86)\Java" | FIND "jdk"
IF '%ERRORLEVEL%'=='0' (
    ECHO File Path JDK 2---
    SET complete=No
    SET jdkFiles=Yes
)

:: Check for newest version
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF '%ERRORLEVEL%'=='0' (
   ECHO PASS - NEW JAVA CHECK ---
   SET completex=No
   SET newJRE=Yes
)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF '%ERRORLEVEL%'=='0' (
   ECHO PASS - NEW JAVA CHECK 2 ---
   SET completex=No
   SET newJRE=Yes
)
:: Java 8 Family Check
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 8 Family ---
   SET completex=No
   set jreEightFam=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 8 Family 2 ---
   SET completex=No
   set jreEightFam=Yes
   set upgradeJRE=Yes
)
:: Java 7 Family Check
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 7 Family ---
   SET completex=No
   set jreSevenFam=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 7 Family 2 ---
   SET completex=No
   set jreSevenFam=Yes
   set upgradeJRE=Yes
)
:: Java 6 Family Check
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java(TM) 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 6 Family ---
   SET completex=No
   set jreSixFam=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java(TM) 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 6 Family 2 ---
   SET completex=No
   set jreSixFam=Yes
   set upgradeJRE=Yes
)
:: JDK 8 Family Check
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 8 Family ---
   SET completex=No
   set jdkEightFam=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 8 Family 2 ---
   SET completex=No
   set jdkEightFam=Yes
)
:: JDK 7 Family Check
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 7 Family ---
   SET completex=No
   set jdkSevenFam=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 7 Family 2 ---
   SET completex=No
   set jdkSevenFam=Yes
)
:: JDK 6 Family Check
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 6 Family ---
   SET completex=No
   set jdkSixFam=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 6 Family 2 ---
   SET completex=No
   set jdkSixFam=Yes
)


::
:: ACTION
::

:: IF new JRE, uninstall old
:: IF new JDK, uninstall old
:: IF updateJREFlag is yes, update
:: IF updateJDKFlag is yes, update


:: Use this to quit everything if Java is not found above
IF "%complete%"=="No" (
   IF "%completex%"=="No" (
      ECHO VERIFIED JAVA ---
   )
) ELSE (
   ECHO ENDING SCRIPT ---
   GOTO :eof
)

:: Then if new Java is installed to this
IF "%newJRE%"=="Yes" (
   ECHO Going to remediation
   GOTO :remediation     
)
IF "%upgradeJRE%"=="Yes" (
   ECHO Upgrading JRE    
)
:: Verify new installation
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF '%ERRORLEVEL%'=='0' (
   ECHO SUCCESSFUL INSTALLATION ---
   GOTO :remediation
)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF '%ERRORLEVEL%'=='0' (
   ECHO SUCCESSFUL INSTALLATION 2 ---
   GOTO :remediation
)

:remediation
IF "%jreEightFam%"=="Yes" (
   ECHO removing JRE 8 Family ---
)
IF "%jreSevenFam%"=="Yes" (
   ECHO removing JRE 7 Family ---
)
IF "%jreSixFam%"=="Yes" (
   ECHO removing JRE 6 Family ---
)   
