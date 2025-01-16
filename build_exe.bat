@echo off
:: Batch file to package Python script into an executable

:: Name of the Python script to be converted
set SCRIPT_NAME=reset_network.py

:: Run PyInstaller to build the executable
pyinstaller --onefile --windowed "%SCRIPT_NAME%"

:: Notify the user
echo Build complete! Your executable is located in the "dist" folder.

:: Play a sound to notify the user
powershell -c (New-Object Media.SoundPlayer "C:\Windows\Media\notify.wav").PlaySync();

:: Execute the generated executable
set EXE_NAME=%SCRIPT_NAME:~0,-3%.exe
start "" "dist\%EXE_NAME%"

pause
