@ECHO OFF
:: Author - Adam Lucero
:: 04/2019
:: Java Remediation Tool


:: Important Info:
:: Finds Java in both Registry and Program Files
:: IF Java is found, upgrade and/or remove old versions
:: Supports Java JRE 8,7,6
:: Disable UAC before Running!



:: EDIT variable to the latest JRE version - variable used elsewhere!!!
:: Format = "Java X Update X"
set latestJava=Java 8 Update 201


::
:: FIND JAVA INSTALLATIONS
::

:verification

:: Program Files
DIR "C:\Program Files\Java" | FIND "jre"
IF '%ERRORLEVEL%'=='0' (
    ECHO Dedected JRE files ---
    SET jreFiles=Yes
)
DIR "C:\Program Files (x86)\Java" | FIND "jre"
IF '%ERRORLEVEL%'=='0' (
    ECHO Dedected JRE files 2 ---
    SET jreFiles=Yes
)
DIR "C:\Program Files\Java" | FIND "jdk"
IF '%ERRORLEVEL%'=='0' (
    ECHO Dedected JDK files ---
    SET jdkFiles=Yes
)
DIR "C:\Program Files (x86)\Java" | FIND "jdk"
IF '%ERRORLEVEL%'=='0' (
    ECHO Dedected JDK files 2 ---
    SET jdkFiles=Yes
)
:: Registry
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected New Java ---
   SET newJRE=Yes
)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected New Java 2 ---
   SET newJRE=Yes
)
:: Java 8 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 8 Family ---
   set jreEightFam=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 8 Family 2 ---
   set jreEightFam=Yes
   set upgradeJRE=Yes
)
:: Java 7 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 7 Family ---
   set jreSevenFam=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 7 Family 2 ---
   set jreSevenFam=Yes
   set upgradeJRE=Yes
)
:: Java 6 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java(TM) 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 6 Family ---
   set jreSixFam=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java(TM) 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected Java 6 Family 2 ---
   set jreSixFam=Yes
   set upgradeJRE=Yes
)
:: JDK 8 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 8 Family ---
   set jdkEightFam=Yes
   set upgradeJDK=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 8 Family 2 ---
   set jdkEightFam=Yes
   set upgradeJDK=Yes
)
:: JDK 7 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 7 Family ---
   set jdkSevenFam=Yes
   set upgradeJDK=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 7 Family 2 ---
   set jdkSevenFam=Yes
   set upgradeJDK=Yes
)
:: JDK 6 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 6 Family ---
   set jdkSixFam=Yes
   set upgradeJDK=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO Detected JDK 6 Family 2 ---
   set jdkSixFam=Yes
   set upgradeJDK=Yes
)


::
:: TAKE ACTION IF
::

:: If the newest JRE was found, remove old JRE
IF "%jreFiles%"=="Yes" (
   IF "%newJRE%"=="Yes" (
      IF "%upgradeVerify%"=="Yes" (
         IF "%upgradeJRE%"=="Yes" (
            ECHO Upgrade Success but old JRE found ---
            SET JREremediation=Yes
            GOTO :jreRemediation            
         ) 
         ECHO Upgrade SUCCESS ---
         GOTO :eof
      )
      ECHO Newest Java found ---
      SET JREremediation=Yes
      GOTO :jreRemediation      
   )    
)

:: If only old JRE was found, upgrade JRE
IF "%jreFiles%"=="Yes" (
   IF "%upgradeJRE%"=="Yes" (
      IF "%upgradeVerify%"=="Yes" (
         ECHO Upgrade FAILED ---
         ECHO ENDING SCRIPT ---
         GOTO :eof
      ) 
      ECHO Upgrading old JRE ---
      E:\Downloads\Java\JRE\jre-8u201-windows-i586.exe /s REMOVEOUTOFDATEJRES=1
      SET upgradeJRE=No
      SET upgradeVerify=Yes
      GOTO :verification
   )
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
