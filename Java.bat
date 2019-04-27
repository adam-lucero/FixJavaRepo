@ECHO OFF

:: If Java is not installed at all, quit this whole operation, go to EOF
wmic product where "Name like '%%Java%%'" LIST BRIEF | findstr Java
IF not errorlevel 1 (
   SET complete=No
) else (
   ECHO No Java detected...
   ECHO Skip
   SET complete=Yes
)
IF "%complete%"=="Yes" (GOTO :eof)


:: STARTING SCRIPT 
::
:: Check for Java 8 Update 201 x86
:: Modify install path for other versions here
IF EXIST "C:\Program Files (x86)\Java\jre1.8.0_201\bin\java.exe" (
 ECHO Java 8 Update 201 x86 detected...
 SET installed=Yes
) else (
 SET installed=No
)

:: Check for Java 8 Update 201 x64
:: Modify install path for other versions here
IF EXIST "C:\Program Files\Java\jre1.8.0_201\bin\java.exe" (
 ECHO Java 8 Update 201 x64 detected...
 SET installedx=Yes
) else (
 SET installedx=No
)

:: Uninstall Java if its installed
IF "%installed%"=="Yes" (
 ECHO Uninstalling old versions...
 wmic product where "Name like '%%Java(TM) 6%%'" call uninstall /nointeractive
 wmic product where "Name like '%%Java 7%%'" call uninstall /nointeractive
 wmic product where "Name like '%%Java 8 Update 1%%'" call uninstall /nointeractive
)
:: Uninstall only if not already uninstalled.
IF "%installedx%"=="Yes" (
 IF "%installed%"=="Yes" (
  ECHO Java 8 x86 and x64 installed...
  ) else (
    ECHO Uninstalling old versions...
    wmic product where "Name like '%%Java(TM) 6%%'" call uninstall /nointeractive
    wmic product where "Name like '%%Java 7%%'" call uninstall /nointeractive
    wmic product where "Name like '%%Java 8 Update 1%%'" call uninstall /nointeractive
  )
)

::Install Java 8 and remove old
IF "%installed%"=="No" (
 IF "%installedx%"=="No" (
  ECHO Upgrading Java...
  E:\Downloads\Java\jre-8u201-windows-i586.exe /s REMOVEOUTOFDATEJRES=1
  ECHO Uninstalling any old versions...
  wmic product where "Name like '%%Java(TM) 6%%'" call uninstall /nointeractive
  wmic product where "Name like '%%Java 7%%'" call uninstall /nointeractive
  wmic product where "Name like '%%Java 8 Update 1%%'" call uninstall /nointeractive
 )
)

:eof