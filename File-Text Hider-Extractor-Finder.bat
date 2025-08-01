@echo off
title File/Text Hider/Extractor/Finder
setlocal
echo Program Name: File/Text Hider/Extractor/Finder
echo Version: 3.0.4
echo License: GNU General Public License v3.0
echo Developer: @YonatanReuvenIsraeli
echo GitHub: https://github.com/YonatanReuvenIsraeli
echo Sponsor: https://github.com/sponsors/YonatanReuvenIsraeli
"%windir%\System32\net.exe" session > nul 2>&1
if not "%errorlevel%"=="0" goto "NotAdministrator"
goto "Start"

:"NotAdministrator"
echo.
echo Please run this batch file as an administrator. Press any key to close this batch file.
pause > nul 2>&1
goto "Done"

:"Start"
echo.
echo [1] Hide file/text.
echo [2] Extract file/text.
echo [3] Find files that have hidden files/text.
echo [4] Close.
echo.
set Input=
set /p Input="What do you want to do? (1-4) "
if /i "%Input%"=="1" goto "HideFileText"
if /i "%Input%"=="2" goto "ExtractFileText"
if /i "%Input%"=="3" goto "FindFolder"
if /i "%Input%"=="4" goto "Done"
echo Invalid syntax!
goto "Start"

:"HideFileText"
echo.
set HideFileText=
set /p HideFileText="Are you trying to hide a file or text? (File/Text) "
if /i "%HideFileText%"=="File" goto "HideFile"
if /i "%HideFileText%"=="Text" goto "HideText"
goto "HideFileText"

:"HideFile"
echo.
set HideFile=
set /p HideFile="What is the full path of the file you are trying to hide? "
if not exist "%HideFile%" goto "NotExistHideFile"
goto "HideFileIn"

:"NotExistHideFile"
echo "%HideFile%" does not exist! Please try again.
goto "HideFile"

:"HideText"
echo.
set HideText=
set /p HideText="Enter the text you are trying to hide. "
goto "HideFileIn"

:"HideFileIn"
echo.
set HideFileIn=
if /i "%HideFileText%"=="File" set /p HideFileIn="What is the full path of the file that you want to hide "%HideFile%" in? "
if /i "%HideFileText%"=="Text" set /p HideFileIn="What is the full path of the file that you want to hide your text in? "
goto "HideStreamName"

:"HideStreamName"
echo.
set HideStreamName=
set /p HideStreamName="What would you like to name this alternate data stream? "
goto "Overwrite"

:"Overwrite"
echo.
set Overwrite=
set /p Overwrite="This will overwrite an alternate data stream with the same name (%HideStreamName%) in "%HideFileIn%" if it exists. Are you sure you want to continue? (Yes/No) "
if /i "%Overwrite%"=="Yes" goto "Hide"
if /i "%Overwrite%"=="No" goto "Start"
echo Invalid syntax!
goto "Overwrite"

:"Hide"
echo.
echo Creating alternate data stream.
if /i "%HideFileText%"=="File" type "%HideFile%" > "%HideFileIn%":"%HideStreamName%"
if /i "%HideFileText%"=="Text" echo %HideText% > "%HideFileIn%":"%HideStreamName%"
if not "%errorlevel%"=="0" goto "HideError"
echo Alternate data stream created!
goto "Start"

:"HideError"
echo There has been an error! You can try again.
goto "Start"

:"ExtractFileText"
echo.
set ExtractFileText=
set /p ExtractFileText="Are you trying to extract a file or text? (File/Text) "
if /i "%ExtractFileText%"=="File" goto "ExtractPath"
if /i "%ExtractFileText%"=="Text" goto "ExtractPath"
goto "ExtractFileText"

:"ExtractPath"
echo.
set ExtractPath=
set /p ExtractPath="What is the full path to the file that the alternate data stream is hidden in? "
if not exist "%ExtractPath%" goto "NotExistExtractPath"
goto "ExtractStreamName"

:"NotExistExtractPath"
echo "%ExtractPath%" does not exist! Please try again.
goto "ExtractPath"

:"ExtractStreamName"
echo.
set ExtractStreamName=
set /p ExtractStreamName="What is the name of the alternate data stream? "
if /i "%ExtractFileText%"=="File" goto "ExtractFolder"
if /i "%ExtractFileText%"=="Text" goto "Extract"

:"ExtractFolder"
echo.
set ExtractFolder=
set /p ExtractFolder="What do you want the full path to the folder of the extracted file to be? "
if not exist "%ExtractFolder%" goto "ExtractFolderNotExist"
goto "FileName"

:"ExtractFolderNotExist"
echo Error! Folder not found. Please try again.
goto "ExtractFolder"

:"FileName"
echo.
set FileName=
set /p FileName="What do you want the extracted file to be named? "
if exist "%ExtractFolder%\%FileName%" goto "FileNameExist"
goto "Extract"

:"FileNameExist"
echo "%ExtractFolder%\%FileName%" already exists! Please rename "%ExtractFolder%\%FileName%" or move "%ExtractFolder%\%FileName%" to another location and try again.
goto "FileName"

:"Extract"
echo.
echo Extracting alternate data stream.
if /i "%ExtractFileText%"=="File" "%windir%\System32\expand.exe" "%ExtractPath%":"%ExtractStreamName%" "%ExtractFolder%\%FileName%" > nul 2>&1
if /i "%ExtractFileText%"=="Text" "%windir%\System32\more.com" < "%ExtractPath%":"%ExtractStreamName%"
if /i "%ExtractFileText%"=="File" if not "%errorlevel%"=="0" goto "ExtractError"
if /i "%ExtractFileText%"=="File" echo Alternate data stream extracted! Your extracted file is at "%ExtractFolder%\%FileName%".
if /i "%ExtractFileText%"=="Text" echo Alternate data stream extracted if "%ExtractPath%":"%ExtractStreamName%" exists!
goto "Start"

:"ExtractError"
echo Error! Invalid alternate data stream. Please try again.
goto "ExtractFileText"

:"FindFolder"
echo.
set FindFolder=
set /p FindFolder="What is the full path to the folder you want to find hidden files that were hidden with this batch file? "
if not exist "%FindFolder%" goto "FindNotExist"
goto "FindSet"

:"FindNotExist"
echo "%FindFolder%" does not exist! Please try again.
goto "FindFolder"

:"FindSet"
set Find=
goto "FindCheck"

:"FindCheck"
cd /d "%SystemDrive%"
cd\
echo.
echo Getting "%FindFolder%" details.
if exist "Find.txt" goto "FindExist"
dir "%FindFolder%" /r | "%windir%\System32\find.exe" /c /i ":$DATA" > "Find.txt"
set /p FindNumber=< "Find.txt"
del "Find.txt" /f /q > nul 2>&1
echo Got "%FindFolder%" details.
if /i "%Find%"=="True" goto "FindDone"
if /i "%FindNumber%"=="0" goto "NoFind"
if /i not "%FindNumber%"=="0" goto "Find"

:"FindExist"
set Find=True
echo.
echo Please temporarily rename to something else or temporarily move to another location "Find.txt" in order for this batch file to proceed. "Find.txt" is not a system file. "Find.txt" is located in the folder "%cd%". Press any key to continue when "Find.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "FindCheck"

:"FindDone"
echo.
echo You can now rename or move the file back to "Find.txt". Press any key to continue.
pause > nul 2>&1
if /i "%FindNumber%"=="0" goto "NoFind"
if /i not "%FindNumber%"=="0" goto "Find"

:"NoFind"
echo.
echo No files that were hidden with this batch file found in "%FindFolder%"!
goto "Start"

:"Find"
echo.
echo %FindNumber% hidden files found!
echo.
dir "%FindFolder%" /r | "%windir%\System32\find.exe" /i ":$DATA"
goto "Start"

:"Done"
endlocal
exit
