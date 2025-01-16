@echo off
:: Batch file to package Python script into an executable

:: Name of the Python script to be converted
set SCRIPT_NAME=reset_network.py

:: Run PyInstaller to build the executable
pyinstaller --onefile --windowed "%SCRIPT_NAME%"

:: Notify the user
echo Build complete! Your executable is located in the "dist" folder.
pause
