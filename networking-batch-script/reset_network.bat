@echo off

:: Create logs folder if it doesn't exist
if not exist logs mkdir logs

:: Get the current date and time for the log filename
for /f "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set datetime=%%I
set datetime=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%
set logfile=logs\%datetime%.log

:: Initialize the log file
echo Logging started at %date% %time% > %logfile%

:: Warning for full functionality
echo WARNING: For full functionality, please run this script as an Administrator. >> %logfile%
echo Some functions may be limited without administrative privileges. >> %logfile%
echo WARNING: For full functionality, please run this script as an Administrator.
echo Some functions may be limited without administrative privileges.
pause

set RUN_ALL_MODE=0

:menu
cls
echo ==========================================
echo Network Troubleshooting Menu
echo ==========================================
echo 1. Flush DNS Cache
echo 2. Clear ARP Cache
echo 3. Test Connectivity
echo 4. Display DNS Cache
echo 5. Display ARP Cache
echo 6. Release and Renew IP Address
echo 7. Check Network Adapter Status
echo 8. Reset Winsock (Admin)
echo 9. Reset TCP/IP Stack (IPv4) (Admin)
echo 10. Reset TCP/IP Stack (IPv6) (Admin)
echo 11. Restart DHCP and DNS Client Services (Admin)
echo 12. Restart Network Adapters (Admin)
echo 13. Reset Network Settings (Admin)
echo 14. Check Internet Connectivity
echo 15. Display Network Configuration
echo 16. Check for Network Driver Updates
echo 17. Run Multiple Commands
echo 18. Run All Commands
echo 19. Help - Detailed explanations for each command
echo 20. Exit
echo ==========================================
set /p choice=Choose an option (1-20):

if "%choice%"=="1" goto flush_dns
if "%choice%"=="2" goto clear_arp
if "%choice%"=="3" goto test_connectivity
if "%choice%"=="4" goto display_dns
if "%choice%"=="5" goto display_arp
if "%choice%"=="6" goto release_renew_ip
if "%choice%"=="7" goto check_adapter_status
if "%choice%"=="8" goto reset_winsock
if "%choice%"=="9" goto reset_ipv4
if "%choice%"=="10" goto reset_ipv6
if "%choice%"=="11" goto restart_services
if "%choice%"=="12" goto restart_adapters
if "%choice%"=="13" goto reset_network_settings
if "%choice%"=="14" goto check_internet_connectivity
if "%choice%"=="15" goto display_network_config
if "%choice%"=="16" goto check_driver_updates
if "%choice%"=="17" goto run_multiple_commands
if "%choice%"=="18" goto run_all
if "%choice%"=="19" goto help
if "%choice%"=="20" goto exit_script
goto menu

:flush_dns
echo Flushing DNS cache... >> %logfile%
ipconfig /flushdns >> %logfile% 2>&1
echo DNS cache flushed. >> %logfile%
echo Flushing DNS cache...
echo DNS cache flushed.
if "%RUN_ALL_MODE%"=="0" pause
if "%RUN_ALL_MODE%"=="0" goto menu
goto :eof

:clear_arp
echo Clearing ARP cache... >> %logfile%
arp -d * >> %logfile% 2>&1
echo ARP cache cleared. >> %logfile%
echo Clearing ARP cache...
echo ARP cache cleared.
if "%RUN_ALL_MODE%"=="0" pause
if "%RUN_ALL_MODE%"=="0" goto menu
goto :eof

:test_connectivity
cls
echo ==========================================
echo Test Connectivity
echo ==========================================
echo 1. Ping Google DNS (8.8.8.8)
echo 2. Ping Cloudflare DNS (1.1.1.1)
echo 3. Enter a custom IP or domain
echo ==========================================
echo.
set /p ping_choice=Choose an option (1-3):

if "%ping_choice%"=="1" set target=8.8.8.8
if "%ping_choice%"=="2" set target=1.1.1.1
if "%ping_choice%"=="3" (
  set /p target=Enter IP or domain:
)
echo Pinging %target%... >> %logfile%
ping %target% >> %logfile% 2>&1
echo Connectivity test completed. If you see replies, the connection is working. >> %logfile%
echo Pinging %target%...
echo Connectivity test completed. If you see replies, the connection is working.
if "%RUN_ALL_MODE%"=="0" pause
if "%RUN_ALL_MODE%"=="0" goto menu
goto :eof

:display_dns
echo Displaying DNS cache... >> %logfile%
ipconfig /displaydns >> %logfile% 2>&1
echo DNS cache displayed. >> %logfile%
echo Displaying DNS cache...
echo DNS cache displayed.
if "%RUN_ALL_MODE%"=="0" pause
if "%RUN_ALL_MODE%"=="0" goto menu
goto :eof

:display_arp
echo Displaying ARP cache... >> %logfile%
arp -a >> %logfile% 2>&1
echo ARP cache displayed. >> %logfile%
echo Displaying ARP cache...
echo ARP cache displayed.
if "%RUN_ALL_MODE%"=="0" pause
if "%RUN_ALL_MODE%"=="0" goto menu
goto :eof

:release_renew_ip
echo Releasing IP address... >> %logfile%
ipconfig /release >> %logfile% 2>&1
echo Renewing IP address... >> %logfile%
ipconfig /renew >> %logfile% 2>&1
echo IP address released and renewed. >> %logfile%
echo Releasing IP address...
echo Renewing IP address...
echo IP address released and renewed.
if "%RUN_ALL_MODE%"=="0" pause
if "%RUN_ALL_MODE%"=="0" goto menu
goto :eof

:check_adapter_status
echo Checking network adapter status... >> %logfile%
netsh interface show interface >> %logfile% 2>&1
echo Network adapter status displayed. >> %logfile%
echo Checking network adapter status...
echo Network adapter status displayed.
if "%RUN_ALL_MODE%"=="0" pause
if "%RUN_ALL_MODE%"=="0" goto menu
goto :eof

:reset_winsock
echo Resetting Winsock... >> %logfile%
netsh winsock reset >> %logfile% 2>&1
echo Winsock reset. Please restart your computer for changes to take effect. >> %logfile%
echo Resetting Winsock...
echo Winsock reset. Please restart your computer for changes to take effect.
if "%RUN_ALL_MODE%"=="0" pause
if "%RUN_ALL_MODE%"=="0" goto menu
goto :eof

:reset_ipv4
echo Resetting IPv4 TCP/IP stack... >> %logfile%
netsh int ip reset >> %logfile% 2>&1
echo IPv4 TCP/IP stack reset. Please restart your computer for changes to take effect. >> %logfile%
echo Resetting IPv4 TCP/IP stack...
echo IPv4 TCP/IP stack reset. Please restart your computer for changes to take effect.
if "%RUN_ALL_MODE%"=="0" pause
if "%RUN_ALL_MODE%"=="0" goto menu
goto :eof

:reset_ipv6
echo Resetting IPv6 TCP/IP stack... >> %logfile%
netsh int ipv6 reset >> %logfile% 2>&1
echo IPv6 TCP/IP stack reset. Please restart your computer for changes to take effect. >> %logfile%
echo Resetting IPv6 TCP/IP stack...
echo IPv6 TCP/IP stack reset. Please restart your computer for changes to take effect.
if "%RUN_ALL_MODE%"=="0" pause
if "%RUN_ALL_MODE%"=="0" goto menu
goto :eof

:restart_services
echo Restarting DHCP and DNS Client services... >> %logfile%
net stop dhcp >> %logfile% 2>&1
net start dhcp >> %logfile% 2>&1
net stop dnscache >> %logfile% 2>&1
net start dnscache >> %logfile% 2>&1
echo DHCP and DNS Client services restarted. >> %logfile%
echo Restarting DHCP and DNS Client services...
echo DHCP and DNS Client services restarted.
if "%RUN_ALL_MODE%"=="0" pause
if "%RUN_ALL_MODE%"=="0" goto menu
goto :eof

:restart_adapters
echo Restarting network adapters... >> %logfile%
for /f "tokens=*" %%A in ('netsh interface show interface ^| findstr /C:"Enabled"') do (
  echo Disabling adapter: %%A >> %logfile%
  netsh interface set interface name="%%A" admin=disable >> %logfile% 2>&1
  timeout /t 2 >nul
  echo Enabling adapter: %%A >> %logfile%
  netsh interface set interface name="%%A" admin=enable >> %logfile% 2>&1
)
echo Network adapters restarted. >> %logfile%
echo Restarting network adapters...
echo Network adapters restarted.
if "%RUN_ALL_MODE%"=="0" pause
if "%RUN_ALL_MODE%"=="0" goto menu
goto :eof

:reset_network_settings
echo Resetting network settings... >> %logfile%
netsh int ip reset >> %logfile% 2>&1
netsh winsock reset >> %logfile% 2>&1
echo Network settings reset. Please restart your computer for changes to take effect. >> %logfile%
echo Resetting network settings...
echo Network settings reset. Please restart your computer for changes to take effect.
if "%RUN_ALL_MODE%"=="0" pause
if "%RUN_ALL_MODE%"=="0" goto menu
goto :eof

:check_internet_connectivity
echo Checking internet connectivity... >> %logfile%
ping www.google.com >> %logfile% 2>&1
echo Internet connectivity check completed. If you see replies, the internet connection is working. >> %logfile%
echo Checking internet connectivity...
echo Internet connectivity check completed. If you see replies, the internet connection is working.
if "%RUN_ALL_MODE%"=="0" pause
if "%RUN_ALL_MODE%"=="0" goto menu
goto :eof

:display_network_config
echo Displaying network configuration... >> %logfile%
ipconfig /all >> %logfile% 2>&1
echo Network configuration displayed. >> %logfile%
echo Displaying network configuration...
echo Network configuration displayed.
if "%RUN_ALL_MODE%"=="0" pause
if "%RUN_ALL_MODE%"=="0" goto menu
goto :eof

:check_driver_updates
echo Checking for network driver updates... >> %logfile%
wmic path win32_pnpentity where "DeviceID like '%%PCI%%'" get DeviceID, Name, Manufacturer, DriverVersion >> %logfile% 2>&1
echo Network driver updates check completed. >> %logfile%
echo Checking for network driver updates...
echo Network driver updates check completed.
if "%RUN_ALL_MODE%"=="0" pause
if "%RUN_ALL_MODE%"=="0" goto menu
goto :eof

:run_multiple_commands
cls
echo ==========================================
echo Run Multiple Commands
echo ==========================================
echo 1. Flush DNS Cache, Reset Winsock, Reset TCP/IP Stack (IPv4), Clear ARP Cache
echo 2. Restart DHCP and DNS Client Services, Restart Network Adapters
echo 3. Reset Network Settings, Check Internet Connectivity
echo 4. Return to Main Menu
echo ==========================================
echo.
set /p multi_choice=Choose an option (1-4):

if "%multi_choice%"=="1" (
  call :flush_dns
  call :reset_winsock
  call :reset_ipv4
  call :clear_arp
  pause
  goto run_multiple_commands
)
if "%multi_choice%"=="2" (
  call :restart_services
  call :restart_adapters
  pause
  goto run_multiple_commands
)
if "%multi_choice%"=="3" (
  call :reset_network_settings
  call :check_internet_connectivity
  pause
  goto run_multiple_commands
)
if "%multi_choice%"=="4" goto menu

goto run_multiple_commands

:run_all
set RUN_ALL_MODE=1
call :flush_dns
call :reset_winsock
call :reset_ipv4
call :reset_ipv6
call :clear_arp
call :restart_services
call :restart_adapters
pause
call :test_connectivity
set RUN_ALL_MODE=0
pause
goto menu

:help
cls
echo ==========================================
echo Help - Detailed Explanations for Each Command
echo ==========================================
echo 1. Flush DNS Cache
echo 2. Clear ARP Cache
echo 3. Test Connectivity
echo 4. Display DNS Cache
echo 5. Display ARP Cache
echo 6. Release and Renew IP Address
echo 7. Check Network Adapter Status
echo 8. Reset Winsock (Admin)
echo 9. Reset TCP/IP Stack (IPv4) (Admin)
echo 10. Reset TCP/IP Stack (IPv6) (Admin)
echo 11. Restart DHCP and DNS Client Services (Admin)
echo 12. Restart Network Adapters (Admin)
echo 13. Reset Network Settings (Admin)
echo 14. Check Internet Connectivity
echo 15. Display Network Configuration
echo 16. Check for Network Driver Updates
echo ==========================================
echo Enter the number of the command you want more information about, or type 'menu' to return to the main menu.
set /p help_choice=Choose an option (1-16 or 'menu'):

if "%help_choice%"=="menu" goto menu

call :display_help %help_choice%
goto help

:display_help
cls
if "%1"=="1" (
  echo Flush DNS Cache
  echo Command: ipconfig /flushdns
  ipconfig /?
)
if "%1"=="2" (
  echo Clear ARP Cache
  echo Command: arp -d *
  arp /?
)
if "%1"=="3" (
  echo Test Connectivity
  echo Command: ping [IP or domain]
  echo For more information on the ping command, use: ping /?
)
if "%1"=="4" (
  echo Display DNS Cache
  echo Command: ipconfig /displaydns
  ipconfig /?
)
if "%1"=="5" (
  echo Display ARP Cache
  echo Command: arp -a
  arp /?
)
if "%1"=="6" (
  echo Release and Renew IP Address
  echo Command: ipconfig /release && ipconfig /renew
  ipconfig /?
)
if "%1"=="7" (
  echo Check Network Adapter Status
  echo Command: netsh interface show interface
  netsh /?
)
if "%1"=="8" (
  echo Reset Winsock (Admin)
  echo Command: netsh winsock reset
  netsh winsock /?
)
if "%1"=="9" (
  echo Reset TCP/IP Stack (IPv4) (Admin)
  echo Command: netsh int ip reset
  netsh int ip /?
)
if "%1"=="10" (
  echo Reset TCP/IP Stack (IPv6) (Admin)
  echo Command: netsh int ipv6 reset
  netsh int ipv6 /?
)
if "%1"=="11" (
  echo Restart DHCP and DNS Client Services (Admin)
  echo Commands: net stop dhcp && net start dhcp && net stop dnscache && net start dnscache
  net /?
)
if "%1"=="12" (
  echo Restart Network Adapters (Admin)
  echo Command: netsh interface set interface name="[Adapter Name]" admin=disable && netsh interface set interface name="[Adapter Name]" admin=enable
  netsh interface /?
)
if "%1"=="13" (
  echo Reset Network Settings (Admin)
  echo Commands: netsh int ip reset && netsh winsock reset
  netsh /?
)
if "%1"=="14" (
  echo Check Internet Connectivity
  echo Command: ping www.google.com
  ping /?
)
if "%1"=="15" (
  echo Display Network Configuration
  echo Command: ipconfig /all
  ipconfig /?
)
if "%1"=="16" (
  echo Check for Network Driver Updates
  echo Command: wmic path win32_pnpentity where "DeviceID like '%%PCI%%'" get DeviceID, Name, Manufacturer, DriverVersion
  wmic /?
)
pause
goto help

:exit_script
echo Press any key to exit...
pause
goto :eof