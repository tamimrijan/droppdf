@echo off
setlocal
title OpenDataLoader PDF Installer

rem ---------- colors (ANSI, works on Windows 10/11) ----------
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "RS=%ESC%[0m"
set "BD=%ESC%[1m"
set "DM=%ESC%[90m"
set "RD=%ESC%[91m"
set "GN=%ESC%[92m"
set "YL=%ESC%[93m"
set "CY=%ESC%[96m"
set "MG=%ESC%[95m"

set "FAIL=0"
set "PYBAD="
set "JBAD="

cls
echo.
echo %CY%  +----------------------------------------------------------+%RS%
echo %CY%  ^|%RS%   %BD%%MG%OpenDataLoader%RS% %BD%PDF%RS%  %DM%//%RS%  %BD%installer agent%RS%                 %CY%^|%RS%
echo %CY%  ^|%RS%   %DM%one time setup: checks your system, then installs%RS%    %CY%^|%RS%
echo %CY%  +----------------------------------------------------------+%RS%
echo.
echo  %YL%[*]%RS% Checking requirements...
echo.

rem ---------- python 3.10+ ----------
set "PYCMD="
python -c "import sys" >nul 2>nul
if not errorlevel 1 set "PYCMD=python"
if not defined PYCMD py -3 -c "import sys" >nul 2>nul
if not defined PYCMD if not errorlevel 1 set "PYCMD=py -3"
if not defined PYCMD goto :pyfail

set "PYVER=unknown"
for /f "tokens=2" %%v in ('%PYCMD% --version 2^>^&1') do set "PYVER=%%v"
%PYCMD% -c "import sys; sys.exit(0 if sys.version_info>=(3,10) else 1)"
if errorlevel 1 goto :pyold
echo  %GN%[+]%RS% Python %PYVER% %DM%^(3.10 or later needed^)%RS%
goto :chkjava

:pyfail
set "PYBAD=1"
echo  %RD%[x]%RS% Python not found %DM%^(3.10 or later needed^)%RS%
set "FAIL=1"
goto :chkjava

:pyold
set "PYBAD=1"
echo  %RD%[x]%RS% Python %PYVER% is too old %DM%^(3.10 or later needed^)%RS%
set "FAIL=1"
goto :chkjava

rem ---------- java 11+ ----------
:chkjava
where java >nul 2>nul
if errorlevel 1 goto :javafail

set "JV="
set "JA="
set "JB="
for /f "tokens=3" %%v in ('java -version 2^>^&1 ^| findstr /i /c:"version"') do if not defined JV set "JV=%%~v"
for /f "tokens=1,2 delims=.-_+" %%a in ("%JV%") do set "JA=%%a" & set "JB=%%b"
if not defined JA goto :javaunknown

set "JM=%JA%"
if "%JA%"=="1" set "JM=%JB%"
set /a JMN=JM+0
if %JMN% lss 11 goto :javaold
echo  %GN%[+]%RS% Java %JV% on PATH %DM%^(11 or later needed^)%RS%
goto :checksdone

:javafail
set "JBAD=1"
echo  %RD%[x]%RS% Java not found on PATH %DM%^(11 or later needed^)%RS%
set "FAIL=1"
goto :checksdone

:javaold
set "JBAD=1"
echo  %RD%[x]%RS% Java %JV% is too old %DM%^(11 or later needed^)%RS%
set "FAIL=1"
goto :checksdone

:javaunknown
echo  %YL%[!]%RS% Java is on PATH but I couldn't read the version.
echo      %DM%run java -version and make sure it is 11 or higher%RS%
goto :checksdone

:checksdone
echo.
if "%FAIL%"=="1" goto :blocked

rem ---------- install ----------
echo  %YL%[*]%RS% Installing...
echo  %DM%    %PYCMD% -m pip install -U opendataloader-pdf%RS%
echo.
%PYCMD% -m pip install -U opendataloader-pdf
if errorlevel 1 goto :pipfail

echo.
where opendataloader-pdf >nul 2>nul
if errorlevel 1 goto :nopath

echo %GN%  +----------------------------------------------------------+%RS%
echo %GN%  ^|%RS%   %BD%%GN%INSTALLED%RS%  opendataloader-pdf is ready to use          %GN%^|%RS%
echo %GN%  +----------------------------------------------------------+%RS%
goto :credit

:nopath
echo %YL%  +----------------------------------------------------------+%RS%
echo %YL%  ^|%RS%   %BD%%YL%INSTALLED, BUT...%RS%                                      %YL%^|%RS%
echo %YL%  +----------------------------------------------------------+%RS%
echo.
echo  %YL%[!]%RS% The command is not on PATH yet.
echo      %DM%close this window and open a new terminal, then try again.%RS%
echo      %DM%if it still fails, add your Python Scripts folder to PATH.%RS%
goto :credit

:credit
echo.
echo %YL%  +----------------------------------------------------------+%RS%
echo %YL%  ^|%RS%   %BD%%YL%ONE TIME ONLY%RS%                                        %YL%^|%RS%
echo %YL%  ^|%RS%   %DM%this installer only needs to run once.%RS%                 %YL%^|%RS%
echo %YL%  ^|%RS%   %DM%from now on, just use%RS% %BD%%CY%pdf_convert.bat%RS%                %YL%^|%RS%
echo %YL%  ^|%RS%   %DM%to convert your PDFs.%RS%                                  %YL%^|%RS%
echo %YL%  +----------------------------------------------------------+%RS%
echo.
echo %MG%  +----------------------------------------------------------+%RS%
echo %MG%  ^|%RS%   %DM%made with%RS% %RD%^<3%RS% %DM%and way too much caffeine%RS%                   %MG%^|%RS%
echo %MG%  ^|%RS%   %BD%Created and maintained by %CY%Tamim%RS% xD                       %MG%^|%RS%
echo %MG%  +----------------------------------------------------------+%RS%
echo.
echo  %DM%press any key to close...%RS%
pause >nul
exit /b

:blocked
echo %RD%  +----------------------------------------------------------+%RS%
echo %RD%  ^|%RS%   %BD%%RD%CAN'T INSTALL YET%RS%  fix the red items first             %RD%^|%RS%
echo %RD%  +----------------------------------------------------------+%RS%
echo.
if "%PYBAD%"=="1" call :pytips
if "%JBAD%"=="1" call :javatips
echo  %DM%need more help? see:%RS% https://opendataloader.org/docs/quick-start-python
echo.
echo  %DM%press any key to close...%RS%
pause >nul
exit /b

:pytips
echo  %YL%[Python]%RS% %BD%how to install%RS%
echo     1. Go to https://www.python.org/downloads/
echo     2. Download Python 3.10 or newer ^(the latest one is fine^)
echo     3. Run the installer and %BD%tick "Add python.exe to PATH"%RS% at the bottom
echo     4. Click Install Now, then close and reopen the terminal
echo        %DM%check with: python --version%RS%
echo.
goto :eof

:javatips
echo  %YL%[Java]%RS% %BD%how to install%RS%
echo     1. Go to https://adoptium.net/
echo     2. Download the Windows installer for JDK 11 or newer ^(17 or 21 is a good pick^)
echo     3. Run it. The installer adds Java to PATH automatically
echo     4. Close and reopen the terminal, then check with: java -version
echo.
echo     %YL%PATH tip:%RS% if java -version still fails after reopening the terminal,
echo     add this folder to your system PATH manually:
echo     %BD%C:\Program Files\Eclipse Adoptium\jdk-^<version^>\bin%RS%
echo     %DM%Start menu ^> "Edit the system environment variables" ^> Environment Variables%RS%
echo     %DM%^> select Path ^> Edit ^> New ^> paste the folder ^> OK%RS%
echo.
goto :eof

:pipfail
echo.
echo  %RD%[x]%RS% pip install failed. Check the error above.
echo      %DM%try running this .bat as a normal user, or check your internet.%RS%
echo.
echo  %DM%press any key to close...%RS%
pause >nul
exit /b
