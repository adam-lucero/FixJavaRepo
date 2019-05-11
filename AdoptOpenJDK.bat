@echo off

DIR "C:\Program Files\Java" | FIND "jre"
IF '%ERRORLEVEL%'=='0' (SET jreFiles=Yes)
DIR "C:\Program Files (x86)\Java" | FIND "jre"
IF '%ERRORLEVEL%'=='0' (SET jreFiles=Yes)
DIR "C:\Program Files\Java" | FIND "jdk"
IF '%ERRORLEVEL%'=='0' (SET jdkFiles=Yes)
DIR "C:\Program Files (x86)\Java" | FIND "jdk"
IF '%ERRORLEVEL%'=='0' (SET jdkFiles=Yes)


Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java"
IF '%ERRORLEVEL%'=='0' (
   set jreEightOne=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "Java"
IF '%ERRORLEVEL%'=='0' (
   set jreEightOne=Yes
   set upgradeJRE=Yes
)
Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit"
IF '%ERRORLEVEL%'=='0' (
   set upgradeJDK=Yes
)
Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v DisplayName | find "SE Development Kit"
IF '%ERRORLEVEL%'=='0' (
   set upgradeJDK=Yes
)


IF "%newJreFiles%"=="Yes" (
   IF "%jreEightNew%"=="Yes" (
      IF "%upgradeVerify%"=="Yes" (
         IF "%upgradeJRE%"=="Yes" (
            ECHO --- Upgrade Success but old JRE found ---
            SET JREremediation=Yes
            GOTO :jreRemediation            
         )
         IF "%remediateJDK%"=="Yes" (
            ECHO --- Upgrade Success but old JDK found ---
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


for /f "tokens=3*" %%A in (
  'Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v UninstallString ^| findstr 26A24AE4-039D-4CA4-87B4-2F'
) do (
  ECHO %%A %%B
)
)

for /f "tokens=3*" %%C in (
  'Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v UninstallString ^| findstr 26A24AE4-039D-4CA4-87B4-2F'
) do (
  ECHO %%C %%D
)
)

for /f "tokens=3*" %%A in (
  'Reg Query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /v UninstallString ^| findstr 3248F0A8-6813-11D6-A77B-00B0D01'
) do (
  ECHO %%A %%B
)
)

for /f "tokens=3*" %%C in (
  'Reg Query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" /s /v UninstallString ^| findstr 3248F0A8-6813-11D6-A77B-00B0D01'
) do (
  ECHO %%C %%D
)
)