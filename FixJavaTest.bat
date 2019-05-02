:: Author - Adam Lucero
:: 04/2019
:: Java Remediation Tool
:: Only works if Windows registry and Program Files have Java data
:: Supports JRE 8,7,6
:: Disable UAC before Running!
@ECHO OFF


::
:: VERIFY JAVA
::

:: Edit this variable to latest version - It's used elsewhere
:: Standard format = Java X Update X
set latestJava=Java 8 Update 201


:: Program Files
DIR "C:\Program Files\Java" | FIND "jre"
IF '%ERRORLEVEL%'=='0' (
    ECHO Dedected JRE files ---
    SET complete=No
    SET jreFiles=Yes
)
DIR "C:\Program Files (x86)\Java" | FIND "jre"
IF '%ERRORLEVEL%'=='0' (
    ECHO Dedected JRE files 2 ---
    SET complete=No
    SET jreFiles=Yes
)
DIR "C:\Program Files\Java" | FIND "jdk"
IF '%ERRORLEVEL%'=='0' (
    ECHO Dedected JDK files ---
    SET complete=No
    SET jdkFiles=Yes
)
DIR "C:\Program Files (x86)\Java" | FIND "jdk"
IF '%ERRORLEVEL%'=='0' (
    ECHO Dedected JDK files 2 ---
    SET complete=No
    SET jdkFiles=Yes
)
:: Registry
:: New version
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected New Java ---
   SET completex=No
   SET newJRE=Yes
)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected New Java 2 ---
   SET completex=No
   SET newJRE=Yes
)
:: Java 8 Family
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
:: Java 7 Family
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
:: Java 6 Family
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
:: JDK 8 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 8 Family ---
   SET completex=No
   set jdkEightFam=Yes
   set upgradeJDK=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 8 Family 2 ---
   SET completex=No
   set jdkEightFam=Yes
   set upgradeJDK=Yes
)
:: JDK 7 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 7 Family ---
   SET completex=No
   set jdkSevenFam=Yes
   set upgradeJDK=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 7 Family 2 ---
   SET completex=No
   set jdkSevenFam=Yes
   set upgradeJDK=Yes
)
:: JDK 6 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 6 Family ---
   SET completex=No
   set jdkSixFam=Yes
   set upgradeJDK=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 6 Family 2 ---
   SET completex=No
   set jdkSixFam=Yes
   set upgradeJDK=Yes
)


::
:: TAKE ACTION
::

:: End script if Java wasn't found
IF "%complete%"=="No" (
   IF "%completex%"=="No" (
      ECHO VERIFIED JAVA ---
   )
) ELSE (
   ECHO ENDING SCRIPT ---
   GOTO :eof
)
:: If new Java found, remove old
IF "%jreFiles%"=="Yes" (
   IF "%newJRE%"=="Yes" (
      ECHO Newest Java found ---
      SET JREremediation=Yes
      GOTO :jreRemediation     
   )    
)
:: If only old JRE, upgrade JRE
IF "%jreFiles%"=="Yes" (
   IF "%upgradeJRE%"=="Yes" (
      ECHO Upgrading old JRE ---    
   )    
)
:: Verify JRE upgrade
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF '%ERRORLEVEL%'=='0' (
   ECHO SUCCESSFUL INSTALLATION ---
   SET JREremediation=Yes
)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF '%ERRORLEVEL%'=='0' (
   ECHO SUCCESSFUL INSTALLATION 2 ---
   SET JREremediation=Yes
)
:: JRE Remediation
:jreRemediation 
IF "%JREremediation%"=="Yes" (
   IF "%jreEightFam%"=="Yes" (
      ECHO removing JRE 8 Family ---
   )
   IF "%jreSevenFam%"=="Yes" (
      ECHO removing JRE 7 Family ---
   )
   IF "%jreSixFam%"=="Yes" (
      ECHO removing JRE 6 Family ---
   )     
)

:: In progress
:: If only old JDK, upgrade JDK
:: Verify upgrade TBD
IF "%upgradeJDK%"=="Yes" (
   ECHO Upgrading old JDK ---
   SET JDKremediation=Yes
)
:: JDK Remediation
IF "%JDKremediation%"=="Yes" (
   IF "%jdkEightFam%"=="Yes" (
      ECHO removing JDK 8 Family ---
   )
   IF "%jdkSevenFam%"=="Yes" (
      ECHO removing JDK 7 Family ---
   )
   IF "%jdkSixFam%"=="Yes" (
      ECHO removing JDK 6 Family ---
   )     
)
:eof