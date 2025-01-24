@echo off
setlocal
title File Hider/Extractor/Finder
echo Program Name: File Hider/Extractor/Finder
echo Version: 2.0.10
echo License: GNU General Public License v3.0
echo Developer: @YonatanReuvenIsraeli
echo GitHub: https://github.com/YonatanReuvenIsraeli
echo Sponsor: https://github.com/sponsors/YonatanReuvenIsraeli
goto "Start"

:"Start"
echo.
echo [1] Hide file.
echo [2] Extract file.
echo [3] Find files.
echo [4] Close.
echo.
set Input=
set /p Input="What do you want to do? (1-4) "
if /i "%Input%"=="1" goto "Hide1"
if /i "%Input%"=="2" goto "Show1"
if /i "%Input%"=="3" goto "Find1"
if /i "%Input%"=="4" goto "4"
echo Invalid syntax!
goto "Start"

:"Hide1"
echo.
set Hide1=
set /p Hide1="What is the full path of the file are you trying to hide? "
if not exist "%Hide1%" goto "NotExistHide1"
goto "Hide2"

:"NotExistHide1"
echo "%Hide1%" does not exist! Please try again.
goto "Hide1"

:"Hide2"
echo.
set Hide2=
set /p Hide2="What is the full path of the file that you want to hide "%Hide1%" in? "
if not exist "%Hide2%" goto "NotExistHide2"
goto "Hide3"

:"NotExistHide2"
echo "%Hide2%" does not exist! Please try again.
goto "Hide2"

:"Hide3"
echo.
set Hide3=
set /p Hide3="What would you like to name this alternate data stream? "
goto "Overwrite"

:"Overwrite"
echo.
set Overwrite=
set /p Overwrite="This will overwrite an alternate data stream with the same name (%Hide3%) in "%Hide2%" if it exists. Are you sure you want to continue? (Yes/No) "
if /i "%Overwrite%"=="Yes" goto "Hide"
if /i "%Overwrite%"=="No" goto "Start"
echo Invalid syntax!
goto "Overwrite"

:"Hide"
echo.
echo Creating alternate data stream.
type "%Hide1%" > "%Hide2%":"%Hide3%"
if not "%errorlevel%"=="0" goto "HideError"
echo Alternate data stream created!
goto "Start"

:"HideError"
echo There has been an error! You can try again.
goto "1"

:"Show1"
echo.
set Show1=
set /p Show1="What is the full path to the file that the alternate data stream is hidden in? "
if not exist "%Show1%" goto "NotExistShow1"
goto "Show2"

:"NotExistShow1"
echo "%Show1%" does not exist! Please try again.
goto "Show1"

:"Show2"
echo.
set Show2=
set /p Show2="What is the name of the alternate data stream? "
goto "Show3"

:"Show3"
echo.
set Show3=
set /p Show3="What do you want the full path to the folder of the extracted file to be? "
if not exist "%Show3%" goto "Show3NotExist"
goto "Show4"

:"Show3NotExist"
echo Error! Path not found. Please try again.
goto "Show3"

:"Show4"
echo.
set Show4=
set /p Show4="What do you want the extracted file to be named? "
if exist "%Show3%\%Show4%" goto "Show4NotExist"
goto "Show"

:"Show4NotExist"
echo "%Show3%\%Show4%" already exists! Please rename "%Show3%\%Show4%" or move "%Show3%\%Show4%" to another location and try again.
goto "Show4"

:"Show"
echo.
echo Extracting alternate data stream.
"%windir%\System32\expand.exe" "%Show1%":"%Show2%" "%Show3%\%Show4%" > nul 2>&1
if not "%errorlevel%"=="0" goto "ShowError"
echo Alternate data stream exracted! Your extracted file is at "%Show3%\%Show4%".
goto "Start"

:"ShowError"
echo Error! Invalid alternate data stream. Please try again.
goto "Show1"

:"Find1"
echo.
set FindFolder=
set /p FindFolder="What is the full path to the folder you want to find hidden files that where hidden with this batch file? "
if not exist "%FindFolder%" goto "FindNotExist"
goto "Find2"

:"FindNotExist"
echo %FindFolder%" does not exist! Please try again.
goto "Find1"

:"Find2"
if exist "Find.txt" goto "FindExist"
echo.
echo Getting "%FindFolder%" details.
dir "%FindFolder%" /r | find /c /i ":$DATA" > "Find.txt"
set /p FindNumber=< "Find.txt"
del "Find.txt" /f /q > nul 2>&1
echo Got "%FindFolder%" details.
if /i "%Find%"=="True" goto "FindDone"
if /i "%FindNumber%"=="0" goto "NoFind"
if /i not "%FindNumber%"=="0" goto "Find3"

:"FindExist"
set Find=True
echo.
echo Please temporary rename to something else or temporary move to another location "Find.txt" in order for this batch file to proceed. "Find.txt" is not a system file. "Find.txt" is located in the folder you ran this batch file from. Press any key to continue when "Find.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "Find2"

:"FindDone"
echo.
echo You can now rename or move back the file back to "Find.txt". Press any key to continue.
pause > nul 2>&1
if /i "%FindNumber%"=="0" goto "NoFind"
if /i not "%FindNumber%"=="0" goto "Find3"

:"NoFind"
echo.
echo No files that were hidden with this batch file found in "%FindFolder%"!
goto "Start"

:"Find3"
echo.
echo %FindNumber% hidden files found!
echo.
dir "%FindFolder%" /r | find /i ":$DATA"
goto "Start"

:"4"
endlocal
exit
