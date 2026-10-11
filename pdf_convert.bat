@echo off
setlocal
title OpenDataLoader PDF Converter

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

set "ARGUSED="

:start
cls
call :banner

rem ---------- checks ----------
echo  %YL%[*]%RS% Checking environment...
where java >nul 2>nul
if errorlevel 1 goto :nojava
echo  %GN%[+]%RS% Java found
where opendataloader-pdf >nul 2>nul
if errorlevel 1 goto :nocmd
echo  %GN%[+]%RS% opendataloader-pdf found
echo.

set "FILES="
set "OUTDIR="

if not "%~1"=="" if not defined ARGUSED goto :havearg

echo  %CY%[?]%RS% %BD%Which PDF?%RS% %DM%drag it into this window or paste the path, then Enter%RS%
echo.
set "INPUT="
set /p "INPUT=%CY% >%RS% "
set "INPUT=%INPUT:"=%"
if "%INPUT%"=="" goto :nofile
if not exist "%INPUT%" goto :notfound
set FILES="%INPUT%"
for %%I in ("%INPUT%") do set "OUTDIR=%%~dpIoutput"
goto :menu

:havearg
set "ARGUSED=1"
set FILES=%*
set "OUTDIR=%~dp1output"
echo  %GN%[+]%RS% Got file from drag and drop
echo.

:menu
echo  %GN%[+]%RS% Input: %BD%%FILES%%RS%
echo.
echo  %CY%[?]%RS% %BD%Pick an output format%RS%
echo.
echo     %YL%1%RS%  Markdown        %DM%clean text, best for reading%RS%
echo     %YL%2%RS%  JSON            %DM%full structure, headings, tables%RS%
echo     %YL%3%RS%  Text            %DM%plain text only%RS%
echo     %YL%4%RS%  HTML            %DM%web page version%RS%
echo     %YL%5%RS%  Markdown + JSON %DM%both in one go%RS%
echo     %YL%6%RS%  Everything      %DM%json, html, pdf, markdown%RS%
echo.
set "CHOICE="
set /p "CHOICE=%CY% >%RS% "

set "FORMAT="
if "%CHOICE%"=="1" set "FORMAT=markdown"
if "%CHOICE%"=="2" set "FORMAT=json"
if "%CHOICE%"=="3" set "FORMAT=text"
if "%CHOICE%"=="4" set "FORMAT=html"
if "%CHOICE%"=="5" set "FORMAT=markdown,json"
if "%CHOICE%"=="6" set "FORMAT=json,html,pdf,markdown"
if "%FORMAT%"=="" goto :invalid

echo.
echo  %YL%[*]%RS% Running conversion  %DM%format: %FORMAT%%RS%
echo  %DM%    opendataloader-pdf %FILES% -o "%OUTDIR%" -f %FORMAT%%RS%
echo.

for /f %%t in ('powershell -nologo -noprofile -command "[DateTimeOffset]::Now.ToUnixTimeSeconds()"') do set "T0=%%t"

opendataloader-pdf %FILES% -o "%OUTDIR%" -f %FORMAT%
if errorlevel 1 goto :failed

for /f %%t in ('powershell -nologo -noprofile -command "[DateTimeOffset]::Now.ToUnixTimeSeconds()"') do set "T1=%%t"
set /a ELAPSED=T1-T0

echo.
echo %GN%  +----------------------------------------------------------+%RS%
echo %GN%  ^|%RS%   %BD%%GN%DONE%RS%  finished in %ELAPSED%s
echo %GN%  +----------------------------------------------------------+%RS%
echo.
echo  %GN%[+]%RS% Saved to: %BD%%OUTDIR%%RS%
echo  %DM%    latest files:%RS%
set /a N=0
for /f "delims=" %%f in ('dir /b /a-d /o-d "%OUTDIR%" 2^>nul') do call :showfile "%%f"
echo.
echo %MG%  +----------------------------------------------------------+%RS%
echo %MG%  ^|%RS%   %DM%made with%RS% %RD%^<3%RS% %DM%and way too much caffeine%RS%                   %MG%^|%RS%
echo %MG%  ^|%RS%   %BD%Created and maintained by %CY%Tamim%RS% xD                       %MG%^|%RS%
echo %MG%  +----------------------------------------------------------+%RS%
echo.
echo  %CY%[?]%RS% %BD%What next?%RS%
echo.
echo     %YL%1%RS%  Open output folder
echo     %YL%2%RS%  Convert again       %DM%same PDF, pick another format%RS%
echo     %YL%3%RS%  Main menu           %DM%start over with a new PDF%RS%
echo     %YL%*%RS%  Any other key       %DM%close the terminal%RS%
echo.

:next
set "KEY="
for /f %%k in ('powershell -nologo -noprofile -command "[Console]::ReadKey($true).KeyChar"') do set "KEY=%%k"
if "%KEY%"=="1" goto :openit
if "%KEY%"=="2" goto :again
if "%KEY%"=="3" goto :start
exit /b

:openit
explorer "%OUTDIR%"
echo  %GN%[+]%RS% Opened folder. %DM%Press 1, 2, 3 or any other key to close.%RS%
goto :next

:again
cls
call :banner
goto :menu

:banner
echo.
echo %CY%  +----------------------------------------------------------+%RS%
echo %CY%  ^|%RS%   %BD%%MG%OpenDataLoader%RS% %BD%PDF%RS%  %DM%//%RS%  %BD%converter agent%RS%                 %CY%^|%RS%
echo %CY%  ^|%RS%   %DM%pdf in, clean data out%RS%                                 %CY%^|%RS%
echo %CY%  +----------------------------------------------------------+%RS%
echo.
goto :eof

:showfile
set /a N+=1
if %N% gtr 8 goto :eof
echo      %DM%-%RS% %~1
goto :eof

:nojava
echo  %RD%[x]%RS% Java not found. Install JDK 11+ and reopen this window.
echo      %DM%check with: java -version%RS%
echo.
pause
exit /b

:nocmd
echo  %RD%[x]%RS% opendataloader-pdf command not found.
echo      %DM%install with: pip install -U opendataloader-pdf%RS%
echo.
pause
exit /b

:nofile
echo.
echo  %RD%[x]%RS% No file given.
echo.
pause
exit /b

:notfound
echo.
echo  %RD%[x]%RS% File not found: %INPUT%
echo.
pause
exit /b

:invalid
echo.
echo  %RD%[x]%RS% Invalid choice, run it again and pick 1 to 6.
echo.
pause
exit /b

:failed
echo.
echo  %RD%[x]%RS% Something went wrong. Check the error above.
echo.
pause
exit /b
