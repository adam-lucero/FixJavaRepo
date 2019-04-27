:: Author - Adam Lucero
:: Title - The MOAB
:: Year - 2019

:: Java remediation tool
:: If Java is not installed, don't do anything
:: If Java is installed, upgrade, and remove old versions
:: Works with x64 and x86 installations

@ECHO OFF
:: If Java is not detected, quit this whole operation, go to EOF
wmic product where "Name like '%%Java%%'" LIST BRIEF | findstr Java
IF not errorlevel 1 (
   SET complete=No
) else (
   ECHO Failed to find ANY Java installed...
   ECHO Skip Device
   SET complete=Yes
)
IF "%complete%"=="Yes" (GOTO :eof)

:: Check for the newest x86 version of Java
:: Modify install path for NEW versions here
IF EXIST "C:\Program Files (x86)\Java\jre1.8.0_201\bin\java.exe" (
 ECHO Detected new Java x86...
 ECHO Removing old versions...
 wmic product where "Name like '%%Java(TM) 6%%'" call uninstall /nointeractive
 wmic product where "Name like '%%Java 7%%'" call uninstall /nointeractive
 wmic product where "Name like '%%Java 8 Update 1%%'" call uninstall /nointeractive
 SET installed=Yes
) else (
 ECHO Failed to find new x86 version...
 SET installed=No
)

:: Check for the newest x64 version of Java
:: Modify install path for Newer versions here
IF EXIST "C:\Program Files\Java\jre1.8.0_201\bin\java.exe" (
 IF "%installed%"=="Yes" (
  ECHO Dedected both new x64 and x86 versions...
  ECHO Uninstalls already complete...
  ) else (
    ECHO Dedected new x64 version...
    wmic product where "Name like '%%Java(TM) 6%%'" call uninstall /nointeractive
    wmic product where "Name like '%%Java 7%%'" call uninstall /nointeractive
    wmic product where "Name like '%%Java 8 Update 1%%'" call uninstall /nointeractive
    SET installedx=Yes
  )
) else (
  ECHO Failed to find new x64 version...
  SET installedx=No
)

:: Older versions of Java have been detected and will be upgraded
IF "%installed%"=="No" (
 IF "%installedx%"=="No" (
  ECHO Detected old Java...
  ECHO Upgrading Java...
  :: EDIT FILE PATH HERE -->
  E:\Downloads\Java\jre-8u201-windows-i586.exe /s REMOVEOUTOFDATEJRES=1
  ECHO Removing old versions...
  wmic product where "Name like '%%Java(TM) 6%%'" call uninstall /nointeractive
  wmic product where "Name like '%%Java 7%%'" call uninstall /nointeractive
  wmic product where "Name like '%%Java 8 Update 1%%'" call uninstall /nointeractive
 )
)

:eof