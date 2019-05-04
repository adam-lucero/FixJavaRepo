@ECHO OFF
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::  Author - Adam Lucero
::  04/2019
::  Java Remediation Tool
::  ONLY Supports Java JRE 8,7,6
::  Disable UAC before Running!!!
::  Command to disable UAC via Registry key
::  reg add  "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::  What does the script do?
::  1. If Java isn't found in both the Registry and Program Files, no changes will be made
::  2. If the newest Java is found, it will remove all old versions
::  3. If an old version is found, it will upgrade, and then remove old versions
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::
::  FIND JAVA  ::
:::::::::::::::::

:verification

:: Program Files
ECHO --- Checking Program Files for Java ---

DIR "C:\Program Files\Java" | FIND "jre"
IF '%ERRORLEVEL%'=='0' (SET jreFiles=Yes)
DIR "C:\Program Files (x86)\Java" | FIND "jre"
IF '%ERRORLEVEL%'=='0' (SET jreFiles=Yes)
DIR "C:\Program Files\Java" | FIND "jdk"
IF '%ERRORLEVEL%'=='0' (SET jdkFiles=Yes)
DIR "C:\Program Files (x86)\Java" | FIND "jdk"
IF '%ERRORLEVEL%'=='0' (SET jdkFiles=Yes)
DIR "C:\Program Files\Java" | FIND "jre1.8.0_201"
IF '%ERRORLEVEL%'=='0' (SET newJreFiles=Yes)
DIR "C:\Program Files (x86)\Java" | FIND "jre1.8.0_201"
IF '%ERRORLEVEL%'=='0' (SET newJreFiles=Yes)

:: Registry
ECHO --- Checking Registry for Java ---

:: Java 8 Update 201
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 201"
IF '%ERRORLEVEL%'=='0' (SET newJRE=Yes)
Reg Query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 201"
IF '%ERRORLEVEL%'=='0' (SET newJRE=Yes)

:: Java 8 Update 1x
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   set jreEightOne=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   set jreEightOne=Yes
   set upgradeJRE=Yes
)
:: Java 8 Update 9x
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 9"
IF '%ERRORLEVEL%'=='0' (
   set jreEightNine=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 9"
IF '%ERRORLEVEL%'=='0' (
   set jreEightNine=Yes
   set upgradeJRE=Yes
)
:: Java 8 Update 7x
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 7"
IF '%ERRORLEVEL%'=='0' (
   set jreEightSeven=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 7"
IF '%ERRORLEVEL%'=='0' (
   set jreEightSeven=Yes
   set upgradeJRE=Yes
)
:: Java 8 Update 6x
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 6"
IF '%ERRORLEVEL%'=='0' (
   set jreEightSix=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 6"
IF '%ERRORLEVEL%'=='0' (
   set jreEightSix=Yes
   set upgradeJRE=Yes
)
:: Java 8 Update 5x
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 5"
IF '%ERRORLEVEL%'=='0' (
   set jreEightFive=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 5"
IF '%ERRORLEVEL%'=='0' (
   set jreEightFive=Yes
   set upgradeJRE=Yes
)
:: Java 8 Update 4x
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 4"
IF '%ERRORLEVEL%'=='0' (
   set jreEightFour=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 4"
IF '%ERRORLEVEL%'=='0' (
   set jreEightFour=Yes
   set upgradeJRE=Yes
)
:: Java 8 Update 3x
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 3"
IF '%ERRORLEVEL%'=='0' (
   set jreEightThree=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 8 Update 3"
IF '%ERRORLEVEL%'=='0' (
   set jreEightThree=Yes
   set upgradeJRE=Yes
)
:: Java 7 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 7"
IF '%ERRORLEVEL%'=='0' (
   set jreSevenFam=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java 7"
IF '%ERRORLEVEL%'=='0' (
   set jreSevenFam=Yes
   set upgradeJRE=Yes
)
:: Java 6 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java(TM) 6"
IF '%ERRORLEVEL%'=='0' (
   set jreSixFam=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java(TM) 6"
IF '%ERRORLEVEL%'=='0' (
   set jreSixFam=Yes
   set upgradeJRE=Yes
)
:: JDK 8 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   set jdkEightFam=Yes
   set upgradeJDK=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 8 Update 1"
IF '%ERRORLEVEL%'=='0' (
   set jdkEightFam=Yes
   set upgradeJDK=Yes
)
:: JDK 7 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 7"
IF '%ERRORLEVEL%'=='0' (
   set jdkSevenFam=Yes
   set upgradeJDK=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 7"
IF '%ERRORLEVEL%'=='0' (
   set jdkSevenFam=Yes
   set upgradeJDK=Yes
)
:: JDK 6 Family
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 6"
IF '%ERRORLEVEL%'=='0' (
   set jdkSixFam=Yes
   set upgradeJDK=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit 6"
IF '%ERRORLEVEL%'=='0' (
   set jdkSixFam=Yes
   set upgradeJDK=Yes
)

:::::::::::::::
::  ANALYZE  ::
:::::::::::::::

:: If the newest JRE was found, remove old JRE
:: If this was an upgrade loop, end, or remove old JRE
IF "%newJreFiles%"=="Yes" (
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
      ECHO --- Newest Java already installed, removing old ---
      SET JREremediation=Yes
      GOTO :jreRemediation      
   )    
)
:: If only old JRE was found, upgrade, and then loop back to the beginning
IF "%jreFiles%"=="Yes" (
   IF "%upgradeJRE%"=="Yes" (
      IF "%upgradeVerify%"=="Yes" (
         ECHO --- Upgrade FAILED ---
         ECHO --- ENDING SCRIPT ---
         GOTO :eof
      ) 
      ECHO --- Upgrading ---
      E:\Downloads\Java\JRE\jre-8u201-windows-i586.exe /s
      SET upgradeJRE=No
      SET upgradeVerify=Yes
      ECHO --- Verifying Upgrade ---
      GOTO :verification
   )
)

:::::::::::::::::
::  REMEDIATE  ::
:::::::::::::::::

:jreRemediation 
IF "%JREremediation%"=="Yes" (
   IF "%jreEightOne%"=="Yes" (
      ECHO --- Removing JRE 8 Update 1x ---
      wmic product where "Name like '%%Java 8 Update 1%%'" call uninstall /nointeractive
   )
   IF "%jreEightNine%"=="Yes" (
      ECHO --- Removing JRE 8 Update 9x ---
      wmic product where "Name like '%%Java 8 Update 9%%'" call uninstall /nointeractive
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
   IF "%jreEightThree%"=="Yes" (
      ECHO --- Removing JRE 8 Update 3x ---
      wmic product where "Name like '%%Java 8 Update 3%%'" call uninstall /nointeractive
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

::::::::::::::::::::::::::
::  JDK In progress...  ::
::::::::::::::::::::::::::

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
