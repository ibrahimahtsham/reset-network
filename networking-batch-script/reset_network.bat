@echo off
setlocal enabledelayedexpansion

:: Create logs folder if it doesn't exist
if not exist logs mkdir logs

:: Get the current date and time for the log filename
for /f "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set datetime=%%I
set datetime=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%
set logfile=logs\%datetime%.log

:: Initialize the log file
echo Logging started at %datetime% >> %logfile%

echo WARNING: For full functionality, please run this script as an Administrator.
echo Some functions may be limited without administrative privileges.
pause

:menu
cls
echo ==========================================
echo Network Troubleshooting Menu | Partially Admin = PA, Fully Admin = FA
echo ==========================================
echo 1. Flush DNS Cache [ipconfig /flushdns]
echo 2. Clear ARP Cache (Fully Admin) [arp -d *]
echo 3. Display DNS Cache [ipconfig /displaydns]
echo 4. Display ARP Cache [arp -a]
echo 5. Release and Renew IP Address (Partially Admin) [ipconfig /release (Not Admin), netsh int ipv6 reset (Partially Admin), netsh winsock reset (Fully Admin)]
echo 6. Check Network Adapter Status [netsh interface show interface]
echo 7. Reset Winsock (Fully Admin) [netsh winsock reset]
echo 8. Reset TCP/IP Stack (IPv4) (Partially Admin) [netsh int ip reset]
echo 9. Reset TCP/IP Stack (IPv6) (Partially Admin) [netsh int ipv6 reset]
echo 10. Restart DHCP and DNS Client Services (Partially Admin) [netsh int ipv6 reset (Partially Admin), netsh winsock reset (Fully Admin)]
echo 11. Restart Network Adapters (Fully Admin) [netsh interface set interface name="Ethernet" admin=disable, netsh interface set interface name="Ethernet" admin=enable]
echo 12. Reset Network Settings (Partially Admin) [netsh int ip reset (Partially Admin), netsh int ipv6 reset (Partially Admin), netsh winsock reset (Fully Admin)]
echo 13. Display Network Configuration [ipconfig /all]
echo 14. Check for Network Driver Updates (Doesn't work, needs to be reworked and not removed) [wmic path win32_pnpentity get caption, driverversion]
echo 15. Run Multiple Commands (The whole menu for this needs to be put back into this menu instead of a separate menu)
echo 16. Run All Commands (Needs to be reworked with a flag that checks if its in run all mode) 
echo 17. Ping an IP 
echo 18. Exit
echo ==========================================
echo.
set /p choice=Choose an option (1-19):

echo. >> %logfile%
echo ============================ >> %logfile%
echo Choice number chosen: %choice% >> %logfile%
echo ============================ >> %logfile%

if "%choice%"=="1" goto flush_dns
if "%choice%"=="2" goto clear_arp_cache
if "%choice%"=="3" goto display_dns_cache
if "%choice%"=="4" goto display_arp_cache
if "%choice%"=="5" goto release_renew_ip
if "%choice%"=="6" goto check_adapter_status
if "%choice%"=="7" goto reset_winsock
if "%choice%"=="8" goto reset_tcp_ipv4
if "%choice%"=="9" goto reset_tcp_ipv6
if "%choice%"=="10" goto restart_dhcp_dns
if "%choice%"=="11" goto restart_adapters
if "%choice%"=="12" goto reset_network_settings
if "%choice%"=="13" goto display_network_config
if "%choice%"=="14" goto check_driver_updates
if "%choice%"=="15" goto run_multiple_commands
if "%choice%"=="16" goto run_all_commands
if "%choice%"=="17" goto ping_ip
if "%choice%"=="18" goto exit_script
goto menu

:flush_dns
call :log_command "ipconfig" "/flushdns" "Flushes and resets the contents of the DNS client resolver cache."
goto menu

:clear_arp_cache
call :log_command "arp" "-d *" "Clears the ARP cache."
goto menu

:display_dns_cache
call :log_command "ipconfig" "/displaydns" "Displays the contents of the DNS client resolver cache."
goto menu

:display_arp_cache
call :log_command "arp" "-a" "Displays the ARP cache."
goto menu

:release_renew_ip
call :log_command "ipconfig" "/release" "Releases the IP address."
call :log_command "ipconfig" "/renew" "Renews the IP address."
goto menu

:check_adapter_status
call :log_command "netsh" "interface show interface" "Displays the status of network adapters."
goto menu

:reset_winsock
call :log_command "netsh" "winsock reset" "Resets Winsock."
goto menu

:reset_tcp_ipv4
call :log_command "netsh" "int ip reset" "Resets TCP/IP stack (IPv4)."
goto menu

:reset_tcp_ipv6
call :log_command "netsh" "int ipv6 reset" "Resets TCP/IP stack (IPv6)."
goto menu

:restart_dhcp_dns
call :log_command "net stop" "dhcp" "Stops the DHCP client service."
call :log_command "net start" "dhcp" "Starts the DHCP client service."
call :log_command "net stop" "dnscache" "Stops the DNS client service."
call :log_command "net start" "dnscache" "Starts the DNS client service."
goto menu

:restart_adapters
call :log_command "netsh" "interface set interface name="Ethernet" admin=disable" "Disables the Ethernet adapter."
call :log_command "netsh" "interface set interface name="Ethernet" admin=enable" "Enables the Ethernet adapter."
goto menu

:reset_network_settings
call :log_command "netsh" "int ip reset" "Resets TCP/IP stack (IPv4)."
call :log_command "netsh" "int ipv6 reset" "Resets TCP/IP stack (IPv6)."
call :log_command "netsh" "winsock reset" "Resets Winsock."
goto menu

:display_network_config
call :log_command "ipconfig" "/all" "Displays the current network configuration."
goto menu

:check_driver_updates
call :log_command "wmic" "path win32_pnpentity get caption, driverversion" "Checks for network driver updates."
goto menu

:run_multiple_commands
cls
echo ==========================================
echo Run Multiple Commands
echo ==========================================
echo 1. Flush DNS Cache, Reset Winsock, Reset TCP/IP Stack (IPv4), Clear ARP Cache
echo 2. Restart DHCP and DNS Client Services, Restart Network Adapters
echo 2. Return to Main Menu
echo ==========================================
echo.
set /p multi_choice=Choose an option (1-3):

if "%multi_choice%"=="1" (
    call :flush_dns
    call :reset_winsock
    call :reset_tcp_ipv4
    call :clear_arp_cache
) else if "%multi_choice%"=="2" (
    call :restart_dhcp_dns
    call :restart_adapters
)  else if "%multi_choice%"=="3" (
    goto menu
) else (
    echo Invalid choice. Please try again.
    pause
    goto run_multiple_commands
)
goto menu

:run_all_commands
call :flush_dns
call :clear_arp_cache
call :display_dns_cache
call :display_arp_cache
call :release_renew_ip
call :check_adapter_status
call :reset_winsock
call :reset_tcp_ipv4
call :reset_tcp_ipv6
call :restart_dhcp_dns
call :restart_adapters
call :reset_network_settings
call :display_network_config
call :check_driver_updates
goto menu

:ping_ip
cls
echo ==========================================
echo Ping an IP
echo ==========================================
echo 1. Ping Google
echo 2. Ping Cloudflare
echo 3. Ping OpenDNS
echo 4. Custom IP
echo 5. Back to Main Menu
echo ==========================================
echo.
set /p ping_choice=Choose an IP to ping (1-5):
if "%ping_choice%"=="1" set ip=www.google.com
if "%ping_choice%"=="2" set ip=1.1.1.1
if "%ping_choice%"=="3" set ip=208.67.222.222
if "%ping_choice%"=="4" (
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
goto ping_ip

:log_command
set command=%1
set args=%2
set description=%3
echo. >> %logfile%
echo ============================ >> %logfile%
echo Command: %command% %args% >> %logfile%
echo Description: %description% >> %logfile%
echo ============================ >> %logfile%
echo. >> %logfile%
echo.
echo ============================
echo Command: %command% %args%
echo Description: %description%
echo ============================
echo.
echo Type 'skip' to skip the command.
echo Type 'help' for more info on the command.
echo Type 'run' or press `Enter` to run the command.
set /p run=input:
echo. >> %logfile%
echo.
if /i "%run%"=="run" (
    echo. >> %logfile%
    echo ============================ >> %logfile%
    echo Running command: %command% %args% >> %logfile%
    echo ============================ >> %logfile%
    echo. >> %logfile%
    echo.
    echo ============================
    echo Running command: %command% %args%
    echo ============================
    echo.
     powershell -Command "& { try { %command% %args% 2>&1 | Tee-Object -FilePath temp_log.txt -Append; Get-Content temp_log.txt | Out-File -FilePath %logfile% -Append -Encoding utf8 } catch { Write-Output $_.Exception.Message | Tee-Object -FilePath temp_log.txt -Append; Get-Content temp_log.txt | Out-File -FilePath %logfile% -Append -Encoding utf8 } }"
    del temp_log.txt
    echo. >> %logfile%
    echo =============== >> %logfile%
    echo End of execution. >> %logfile%
    echo =============== >> %logfile%
    echo. >> %logfile%
    echo.
    echo ===============
    echo End of execution.
    echo ===============
    echo.
    pause
) else if /i "%run%"=="help" (
    echo ============================ >> %logfile%
    %command% /? >> %logfile% 2>&1
    echo ============================
    %command% /?
    pause
) else if /i "%run%"=="skip" (
    echo Skipping command: %command% %args% >> %logfile%
    echo Command skipped. >> %logfile%
    echo Command skipped.
    pause
) else (
    echo Invalid input. Please try again.
    pause
)
goto :eof

:exit_script
echo Logging ended at %date% %time% >> %logfile%
echo Logging ended at %date% %time%
pause
endlocal
exit /b