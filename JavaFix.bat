@ECHO OFF
:: Author - Adam Lucero
:: 04/2019
:: Java Remediation Tool
:: Supports Java JRE 8,7,6
:: Disable UAC before Running!!!
:: Command to disable UAC via Registry key
:: reg add  "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f

:: What does the script do?
:: 1. Quits if Java isn't found in both the Registry and Program Files
:: 2. If the newest Java is found, it will remove all old versions
:: 3. If an old version is found, it will upgrade, and then remove old versions

:: EDIT this variable to the latest JRE version!!!
:: Format = "Java X Update X"
set latestJava=Java 8 Update 201



::
:: FIND JAVA INSTALLATIONS
::

:verification

:: Program Files
DIR "C:\Program Files\Java" | FIND "jre"
IF '%ERRORLEVEL%'=='0' (
    ECHO --- Found JRE Program Files ---
    SET jreFiles=Yes
)
DIR "C:\Program Files (x86)\Java" | FIND "jre"
IF '%ERRORLEVEL%'=='0' (
    ECHO --- Found JRE Program Files x86 ---
    SET jreFiles=Yes
)
DIR "C:\Program Files\Java" | FIND "jdk"
IF '%ERRORLEVEL%'=='0' (
    ECHO --- Found JDK Program Files ---
    SET jdkFiles=Yes
)
DIR "C:\Program Files (x86)\Java" | FIND "jdk"
IF '%ERRORLEVEL%'=='0' (
    ECHO --- Found JDK Program Files x86 ---
    SET jdkFiles=Yes
)
:: Registry
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found New Java ---
   SET newJRE=Yes
)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "%latestJava%"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found New Java x86 ---
   SET newJRE=Yes
)
:: Java 8 Update 1x
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 8 Update 1x ---
   set jreEightOne=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 8 Update 1x x86 ---
   set jreEightOne=Yes
   set upgradeJRE=Yes
)
:: Java 8 Update 9x
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 9"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 8 Update 9x ---
   set jreEightNine=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 9"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 8 Update 9x x86 ---
   set jreEightNine=Yes
   set upgradeJRE=Yes
)
:: Java 8 Update 8x
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 8"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 8 Update 8x ---
   set jreEightEight=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 8"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 8 Update 8x x86 ---
   set jreEightEight=Yes
   set upgradeJRE=Yes
)
:: Java 8 Update 7x
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 8 Update 7x ---
   set jreEightSeven=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 8 Update 7x x86 ---
   set jreEightSeven=Yes
   set upgradeJRE=Yes
)
:: Java 8 Update 6x
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 8 Update 6x ---
   set jreEightSix=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 8 Update 6x x86 ---
   set jreEightSix=Yes
   set upgradeJRE=Yes
)
:: Java 8 Update 5x
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 5"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 8 Update 5x---
   set jreEightFive=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 5"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 8 Update 5x x86 ---
   set jreEightFive=Yes
   set upgradeJRE=Yes
)
:: Java 8 Update 4x
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 4"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 8 Update 4x ---
   set jreEightFour=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 4"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 8 Update 4x x86 ---
   set jreEightFour=Yes
   set upgradeJRE=Yes
)
:: Java 7 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 7 Family ---
   set jreSevenFam=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 7 Family x86 ---
   set jreSevenFam=Yes
   set upgradeJRE=Yes
)
:: Java 6 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java(TM) 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 6 Family ---
   set jreSixFam=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java(TM) 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found Java 6 Family x86 ---
   set jreSixFam=Yes
   set upgradeJRE=Yes
)
:: JDK 8 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found JDK 8 Family ---
   set jdkEightFam=Yes
   set upgradeJDK=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found JDK 8 Family x86 ---
   set jdkEightFam=Yes
   set upgradeJDK=Yes
)
:: JDK 7 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found JDK 7 Family ---
   set jdkSevenFam=Yes
   set upgradeJDK=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 7"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found JDK 7 Family x86 ---
   set jdkSevenFam=Yes
   set upgradeJDK=Yes
)
:: JDK 6 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found JDK 6 Family ---
   set jdkSixFam=Yes
   set upgradeJDK=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 6"
IF '%ERRORLEVEL%'=='0' (
   ECHO --- Found JDK 6 Family x86 ---
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
            ECHO --- Upgrade Success but old JRE found ---
            SET JREremediation=Yes
            GOTO :jreRemediation            
         ) 
         ECHO --- Upgrade SUCCESS ---
         GOTO :eof
      )
      ECHO --- Newest Java found ---
      SET JREremediation=Yes
      GOTO :jreRemediation      
   )    
)

:: If only old JRE was found, upgrade JRE
IF "%jreFiles%"=="Yes" (
   IF "%upgradeJRE%"=="Yes" (
      IF "%upgradeVerify%"=="Yes" (
         ECHO --- Upgrade FAILED ---
         ECHO --- ENDING SCRIPT ---
         GOTO :eof
      ) 
      ECHO --- Upgrading old JRE ---
      E:\Downloads\Java\JRE\jre-8u201-windows-i586.exe /s REMOVEOUTOFDATEJRES=1
      SET upgradeJRE=No
      SET upgradeVerify=Yes
      GOTO :verification
   )
)

:: JRE Remediation
:jreRemediation 
IF "%JREremediation%"=="Yes" (
   IF "%jreEightOne%"=="Yes" (
      ECHO --- Removing JRE 8 Family ---
      wmic product where "Name like '%%Java 8 Update 1%%'" call uninstall /nointeractive
   )
   IF "%jreEightNine%"=="Yes" (
      ECHO --- Removing JRE 8 Update 9x ---
      wmic product where "Name like '%%Java 8 Update 9%%'" call uninstall /nointeractive
   )
   IF "%jreEightEight%"=="Yes" (
      ECHO --- Removing JRE 8 Update 8x ---
      wmic product where "Name like '%%Java 8 Update 8%%'" call uninstall /nointeractive
   )
   IF "%jreEightSeven%"=="Yes" (
      ECHO --- Removing JRE 8 Update 7x ---
      wmic product where "Name like '%%Java 8 Update 7%%'" call uninstall /nointeractive
   )
   IF "%jreEightSix%"=="Yes" (
      ECHO --- Removing JRE 8 Update 6x ---
      wmic product where "Name like '%%Java 8 Update 6%%'" call uninstall /nointeractive
   )
   IF "%jreEightFive%"=="Yes" (
      ECHO --- Removing JRE 8 Update 5x ---
      wmic product where "Name like '%%Java 8 Update 5%%'" call uninstall /nointeractive
   )
   IF "%jreEightFour%"=="Yes" (
      ECHO --- Removing JRE 8 Update 4x ---
      wmic product where "Name like '%%Java 8 Update 4%%'" call uninstall /nointeractive
   )   
   IF "%jreSevenFam%"=="Yes" (
      ECHO --- Removing JRE 7 Family ---
      wmic product where "Name like '%%Java 7%%'" call uninstall /nointeractive
   )
   IF "%jreSixFam%"=="Yes" (
      ECHO --- Removing JRE 6 Family ---
      wmic product where "Name like '%%Java(TM) 6%%'" call uninstall /nointeractive
   )
   ECHO --- Removing Program Files ---
   RMDIR /S /Q "C:\Program Files\Java\jre7"
   RMDIR /S /Q "C:\Program Files (x86)\Java\jre7"
   RMDIR /S /Q "C:\Program Files\Java\jre6"
   RMDIR /S /Q "C:\Program Files (x86)\Java\jre6"
)

:: In progress...
:: If only old JDK, upgrade JDK
:: Verify upgrade TBD
IF "%upgradeJDK%"=="Yes" (
   ECHO --- Need to update old JDK ---
   SET JDKremediation=Yes
)
:: JDK Remediation
IF "%JDKremediation%"=="Yes" (
   IF "%jdkEightFam%"=="Yes" (
      ECHO --- JDK 8 Family ---
   )
   IF "%jdkSevenFam%"=="Yes" (
      ECHO --- JDK 7 Family ---
   )
   IF "%jdkSixFam%"=="Yes" (
      ECHO --- JDK 6 Family ---
   )     
)
:eof
