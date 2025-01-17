@echo off
setlocal enabledelayedexpansion

:: Create logs folder if it doesn't exist
if not exist logs mkdir logs

:: Get the current date and time for the log filename
for /f "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set datetime=%%I
set datetime=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%-%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%
set logfile=logs\%datetime%.log

:: Initialize the log file
echo Logging started at %datetime% >> %logfile%

echo WARNING: For full functionality, please run this script as an Administrator.
echo Some functions may be limited without administrative privileges.
pause

:menu
cls
echo ============================================================
echo Network Troubleshooting Menu ^| Partially Admin = PA, Fully Admin = FA, Non Admin = NA
echo ============================================================
echo.
echo 1. Flush DNS Cache (NA) [ipconfig /flushdns]
echo 2. Display DNS Cache (NA) [ipconfig /displaydns]
echo 3. Display ARP Cache (NA) [arp -a]
echo 4. Check Network Adapter Status (NA) [netsh interface show interface]
echo 5. Display Network Configuration (NA) [ipconfig /all]
echo 6. Check for Network Driver Updates (NA) [powershell -Command Get-WmiObject Win32_PnPEntity ^| Select-Object Caption, DriverVersion]
echo 7. Release and Renew IP Address (NA) [ipconfig /release, ipconfig /renew]
echo 8. Reset TCP/IP Stack (IPv4) (PA) [netsh int ip reset]
echo 9. Reset TCP/IP Stack (IPv6) (PA) [netsh int ipv6 reset]
echo 10. Reset Network Settings (PA) [netsh int ip reset, netsh int ipv6 reset, netsh winsock reset]
echo 11. Flush DNS Cache, Reset Winsock, Reset TCP/IP Stack (IPv4), Clear ARP Cache (PA) [ipconfig /flushdns, netsh winsock reset, netsh int ip reset, arp -d *]
echo 12. Clear ARP Cache (FA) [arp -d *]
echo 13. Reset Winsock (FA) [netsh winsock reset]
echo 14. Restart Network Adapters (FA) [netsh interface set interface name="Ethernet" admin=disable, netsh interface set interface name="Ethernet" admin=enable]
echo 15. Run All Commands
echo 16. Restart DHCP and DNS Client Services [net stop dhcp y, net start dhcp, net stop dnscache y, net start dnscache] (not implemented)
echo 17. Restart DHCP and DNS Client Services, Restart Network Adapters (FA) (not implemented)
echo 18. Ping an IP
echo 19. Exit
echo ============================================================
echo.
set /p choice=Choose an option (1-19):

echo. >> %logfile%
echo ============================================================ >> %logfile%
echo Choice number chosen: %choice% >> %logfile%
echo ============================================================ >> %logfile%
echo. >> %logfile%

if "%choice%"=="1" goto flush_dns
if "%choice%"=="2" goto display_dns_cache
if "%choice%"=="3" goto display_arp_cache
if "%choice%"=="4" goto check_adapter_status
if "%choice%"=="5" goto display_network_config
if "%choice%"=="6" goto check_driver_updates
if "%choice%"=="7" goto release_renew_ip
if "%choice%"=="8" goto reset_tcp_ipv4
if "%choice%"=="9" goto reset_tcp_ipv6
if "%choice%"=="10" goto reset_network_settings
if "%choice%"=="11" goto flush_dns_reset_winsock_reset_tcp_ipv4_clear_arp_cache
if "%choice%"=="12" goto clear_arp_cache
if "%choice%"=="13" goto reset_winsock
if "%choice%"=="14" goto restart_adapters
if "%choice%"=="15" set RUN_ALL_MODE=true & goto run_all_commands
if "%choice%"=="16" goto restart_dhcp_dns
if "%choice%"=="17" goto restart_dhcp_dns_restart_adapters
if "%choice%"=="18" goto ping_ip
if "%choice%"=="19" goto exit_script

echo Invalid choice. Please try again.
pause
goto menu

:flush_dns
call :log_command "ipconfig" "/flushdns" "Flushes and resets the contents of the DNS client resolver cache."
if not defined RUN_ALL_MODE goto menu

:display_dns_cache
call :log_command "ipconfig" "/displaydns" "Displays the contents of the DNS client resolver cache."
if not defined RUN_ALL_MODE goto menu

:display_arp_cache
call :log_command "arp" "-a" "Displays the ARP cache."
if not defined RUN_ALL_MODE goto menu

:check_adapter_status
call :log_command "netsh" "interface show interface" "Displays the status of network adapters."
if not defined RUN_ALL_MODE goto menu

:display_network_config
call :log_command "ipconfig" "/all" "Displays the current network configuration."
if not defined RUN_ALL_MODE goto menu

:check_driver_updates
call :log_command_ps "Get-WmiObject Win32_PnPEntity | Select-Object Caption, DriverVersion" "Displays network driver information."
if not defined RUN_ALL_MODE goto menu

:release_renew_ip
call :log_command "ipconfig" "/release" "Releases the IP address."
call :log_command "ipconfig" "/renew" "Renews the IP address."
if not defined RUN_ALL_MODE goto menu

:reset_tcp_ipv4
call :log_command "netsh" "int ip reset" "Resets TCP/IP stack (IPv4)."
if not defined RUN_ALL_MODE goto menu

:reset_tcp_ipv6
call :log_command "netsh" "int ipv6 reset" "Resets TCP/IP stack (IPv6)."
if not defined RUN_ALL_MODE goto menu

:reset_network_settings
call :log_command "netsh" "int ip reset" "Resets TCP/IP stack (IPv4)."
call :log_command "netsh" "int ipv6 reset" "Resets TCP/IP stack (IPv6)."
call :log_command "netsh" "winsock reset" "Resets Winsock."
if not defined RUN_ALL_MODE goto menu

:flush_dns_reset_winsock_reset_tcp_ipv4_clear_arp_cache
call :log_command "ipconfig" "/flushdns" "Flushes and resets the contents of the DNS client resolver cache."
call :log_command "netsh" "winsock reset" "Resets Winsock."
call :log_command "netsh" "int ip reset" "Resets TCP/IP stack (IPv4)."
call :log_command_ps "arp -d *" "Clears the ARP cache. (this command does not produce any output don't worry if its blank it silently does it)"
if not defined RUN_ALL_MODE goto menu

:clear_arp_cache
call :log_command_ps "arp -d *" "Clears the ARP cache. (this command does not produce any output don't worry if its blank it silently does it)"
if not defined RUN_ALL_MODE goto menu

:reset_winsock
call :log_command "netsh" "winsock reset" "Resets Winsock."
if not defined RUN_ALL_MODE goto menu

:restart_adapters
call :log_command "netsh" "interface show interface" "Displays the status of network adapters."
call :log_command "netsh" "interface set interface name="Ethernet" admin=disable" "Disables the Ethernet adapter. (this command does not produce any output don't worry if its blank it silently does it)"
call :log_command "netsh" "interface show interface" "Displays the status of network adapters."
call :log_command "netsh" "interface set interface name="Ethernet" admin=enable" "Enables the Ethernet adapter. (this command does not produce any output don't worry if its blank it silently does it)"
call :log_command "netsh" "interface show interface" "Displays the status of network adapters."
if not defined RUN_ALL_MODE goto menu

:run_all_commands
set RUN_ALL_MODE=true
goto flush_dns
goto display_dns_cache
goto display_arp_cache
goto check_adapter_status
goto display_network_config
goto check_driver_updates
goto release_renew_ip
goto reset_tcp_ipv4
goto reset_tcp_ipv6
goto reset_network_settings
goto flush_dns_reset_winsock_reset_tcp_ipv4_clear_arp_cache
goto clear_arp_cache
goto reset_winsock
goto restart_adapters
set RUN_ALL_MODE=
goto menu

:restart_dhcp_dns
echo: This has not been implemented yet.
echo: Please run the following commands manually:
echo: net stop dhcp
echo: net start dhcp
echo: net stop dnscache
echo: net start dnscache
pause
goto menu

:restart_dhcp_dns_restart_adapters
echo: This has not been implemented yet.
echo: Please run the following commands manually:
echo: net stop dhcp
echo: net start dhcp
echo: net stop dnscache
echo: net start dnscache
echo: netsh interface show interface
echo: netsh interface set interface name="Ethernet" admin=disable
echo: netsh interface show interface
echo: netsh interface set interface name="Ethernet" admin=enable
echo: netsh interface show interface
pause
goto menu

:ping_ip
cls
echo ============================================================
echo Ping an IP
echo ============================================================
echo.
echo 1. Ping Google
echo 2. Ping Cloudflare
echo 3. Ping OpenDNS
echo 4. Custom IP
echo 5. Back to Main Menu
echo ============================================================
echo.
set /p ping_choice=Choose an IP to ping (1-5):
if "%ping_choice%"=="1" set ip=www.google.com
if "%ping_choice%"=="2" set ip=1.1.1.1
if "%ping_choice%"=="3" set ip=208.67.222.222
if "%ping_choice%"=="4" (
    echo.
    set /p ip=Enter the IP or domain to ping:
)
if "%ping_choice%"=="5" goto menu

if "%ping_choice%"=="1" goto ping_ip_execute
if "%ping_choice%"=="2" goto ping_ip_execute
if "%ping_choice%"=="3" goto ping_ip_execute
if "%ping_choice%"=="4" goto ping_ip_execute
goto ping_ip_invalid

:ping_ip_invalid
echo Invalid choice. Please try again.
pause
goto ping_ip

:ping_ip_execute
call :log_command "ping" "%ip%" "Pings the specified IP or domain."
goto menu

:exit_script
echo Logging ended at %date% %time% >> %logfile%
echo Logging ended at %date% %time%
pause
endlocal
exit /b

:log_command
set command=%1
set args=%2
set description=%3
echo. >> %logfile%
echo ============================================================ >> %logfile%
echo Command: %command% %args% >> %logfile%
echo Description: %description% >> %logfile%
echo ============================================================ >> %logfile%
echo. >> %logfile%
echo.
echo ============================================================
echo Command: %command% %args%
echo Description: %description%
echo ============================================================
echo.
echo Type 's' to skip the command.
echo Type 'h' for more info on the command.
echo Type 'r' or press `Enter` to run the command.
echo ------------------------------------------------------------
set /p run=input:
echo. >> %logfile%
echo.
if /i "%run%"=="r" (
    echo. >> %logfile%
    echo ============================================================ >> %logfile%
    echo Running command: %command% %args% >> %logfile%
    echo ============================================================ >> %logfile%
    echo. >> %logfile%
    echo.
    echo ============================================================
    echo Running command: %command% %args%
    echo ============================================================
    echo.
    powershell -Command "& { try { %command% %args% 2>&1 | Tee-Object -FilePath temp_log.txt -Append; Get-Content temp_log.txt | Out-File -FilePath %logfile% -Append -Encoding utf8 } catch { Write-Output $_.Exception.Message | Tee-Object -FilePath temp_log.txt -Append; Get-Content temp_log.txt | Out-File -FilePath %logfile% -Append -Encoding utf8 } }"
    if exist temp_log.txt del temp_log.txt
    echo. >> %logfile%
    echo ============================================================ >> %logfile%
    echo End of execution. >> %logfile%
    echo ============================================================ >> %logfile%
    echo. >> %logfile%
    echo.
    echo ============================================================
    echo End of execution.
    echo ============================================================
    echo.
    pause
) else if /i "%run%"=="h" (
    echo ============================================================ >> %logfile%
    %command% /? >> %logfile% 2>&1
    echo ============================================================
    %command% /?
    pause
) else if /i "%run%"=="s" (
    echo Skipping command: %command% %args% >> %logfile%
    echo Command skipped. >> %logfile%
    echo Command skipped.
    pause
) else (
    echo Invalid input. Please try again.
    pause
)
goto :eof

:log_command_ps
set command=%1
set description=%2
echo. >> %logfile%
echo ============================================================ >> %logfile%
echo Command: %command%  >> %logfile%
echo Description: %description% >> %logfile%
echo ============================================================ >> %logfile%
echo. >> %logfile%
echo.
echo ============================================================
echo Command: %command% 
echo Description: %description%
echo ============================================================
echo.
echo Type 's' to skip the command.
echo Type 'h' for more info on the command.
echo Type 'r' or press `Enter` to run the command.
echo ------------------------------------------------------------
set /p run=input:
echo. >> %logfile%
echo.
if /i "%run%"=="r" (
    echo. >> %logfile%
    echo ============================================================ >> %logfile%
    echo Running command in PowerShell: %command%  >> %logfile%
    echo ============================================================ >> %logfile%
    echo. >> %logfile%
    echo.
    echo ============================================================
    echo Running command in PowerShell: %command% 
    echo ============================================================
    echo.
    powershell -Command %command%
    echo. >> %logfile%
    echo ============================================================ >> %logfile%
    echo End of execution. >> %logfile%
    echo ============================================================ >> %logfile%
    echo. >> %logfile%
    echo.
    echo ============================================================
    echo End of execution.
    echo ============================================================
    echo.
    pause
) else if /i "%run%"=="h" (
    echo ============================================================ >> %logfile%
    %command% /? >> %logfile% 2>&1
    echo ============================================================
    %command% /?
    pause
) else if /i "%run%"=="s" (
    echo Skipping command: %command% >> %logfile%
    echo Command skipped. >> %logfile%
    echo Command skipped.
    pause
) else (
    echo Invalid input. Please try again.
    pause
)
goto :eof