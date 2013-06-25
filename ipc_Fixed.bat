@ECHO OFF
ECHO GNU General Public License :
ECHO.
ECHO This program is free software: 
ECHO you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
ECHO.
ECHO This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
ECHO.
ECHO You should have received a copy of the GNU General Public License along with this program.  If not, see ^<http://www.gnu.org/licenses/^>.
ECHO.
ECHO.
ECHO Spine, Inc., hereby disclaims all copyright interest in the program
ECHO  “ipc_Fixed” written by Chanhee Jeong.
ECHO.
ECHO Chanhee Jeong, 01 June 2013
ECHO.
ECHO.
ECHO Preparing . . .
choice /C X /T 1 /D X > nul
ECHO *******************************************************************************
ECHO.

REM Identify OS.
ver | find /i "version 6.2." > nul
if %errorlevel%==0 (
set $VERSIONWINDOWS=Windows 8
SET LOCATION=Wi-Fi
goto P
)
ver | find /i "version 6.1." > nul
if %errorlevel%==0 (
set $VERSIONWINDOWS=Windows 7
SET LOCATION=Wireless Network Connection
goto P
)
ver | find /i "version 6.0." > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows Vista
ver | find /i "version 5.1." > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows XP
ver | find /i "version 5.2." > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows 2003
ver | find /i "Windows 2000" > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows 2000
ver | find /i "Windows NT" > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows NT
ver | find /i ">Windows ME" > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows ME
ver | find /i "Windows 98" > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows 98
ver | find /i "Windows 95" > nul
if %errorlevel%==0 set $VERSIONWINDOWS=Windows 95

REM set default location
SET LOCATION=Wireless Network Connection

:P

REM Identify bit
IF NOT EXIST "%SYSTEMDRIVE%\Program Files (x86)" set $VERSIONBIT=32 bit
IF EXIST "%SYSTEMDRIVE%\Program Files (x86)" set $VERSIONBIT=64 bit

REM Display result
echo Detected OS : %$VERSIONWINDOWS% %$VERSIONBIT%
echo.
ECHO Network Name : %LOCATION%
echo.

if exist IP.txt goto B

:A

ECHO No IP presets detected . . .
ECHO.
ECHO "Please enter Static IP Address Information" 
ECHO Static IP Address :
SET /p IP_Addr=

ECHO Subnet Mask :
SET /p Sub_Mask=

ECHO Default Gateway :
SET /p D_Gate=

ECHO.

ECHO "Please enter DNS Information"
ECHO Preferred DNS :
SET /p DNS_01=

ECHO "Alternate DNS : " 
SET /p DNS_02=

ECHO.
ECHO.
ECHO Saving settings . . .
choice /C X /T 3 /D X > nul
ECHO.
ECHO IP_Addr=%IP_Addr% > IP.txt
ECHO Sub_Mask=%Sub_Mask% >> IP.txt
ECHO D_Gate=%D_Gate% >> IP.txt
ECHO DNS_01=%DNS_01% >> IP.txt
ECHO DNS_02=%DNS_02% >> IP.txt
ECHO Presets saved!
choice /C X /T 2 /D X > nul
ECHO.

:ASSIGN

ECHO.
ECHO Setting IP, Subnet Mask, Gateway . . .

netsh interface ip SET address name="%LOCATION%" source=static addr=%IP_Addr% mask=%Sub_Mask% gateway=%D_Gate% gwmetric=1

ECHO.

ECHO Setting preferred DNS server . . . 
@netsh interface ip SET dns "%LOCATION%" static %DNS_01% register=PRIMARY validate=no
ECHO Setting alternate DNS server . . .
netsh interface ip add dns "%LOCATION%" %DNS_02% index=2 validate=no

ECHO.
ECHO DONE!
ECHO.

goto end

:B

for /F "tokens=*" %%I in (IP.txt) do @ECHO SET %%I >> tempresets.bat

call tempresets.bat

goto ASSIGN

:end

if exist tempresets.bat del tempresets.bat

ECHO.
pause
