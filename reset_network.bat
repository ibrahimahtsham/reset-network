@echo off
set LOGFILE=network_reset.log
:menu
cls
echo ==========================================
echo Comprehensive Network Reset Menu
echo ==========================================
echo 1. Flush DNS Cache
echo 2. Reset Winsock
echo 3. Reset TCP/IP Stack (IPv4)
echo 4. Reset TCP/IP Stack (IPv6)
echo 5. Clear ARP Cache
echo 6. Restart DHCP and DNS Client Services
echo 7. Ensure Cloudflare WARP Service is Running
echo 8. Restart Network Adapters
echo 9. Test Connectivity to a Minecraft Server
echo 10. Run All Actions
echo 11. Exit
echo ==========================================
set /p choice=Choose an option (1-11): 

if "%choice%"=="1" goto flush_dns
if "%choice%"=="2" goto reset_winsock
if "%choice%"=="3" goto reset_ipv4
if "%choice%"=="4" goto reset_ipv6
if "%choice%"=="5" goto clear_arp
if "%choice%"=="6" goto restart_services
if "%choice%"=="7" goto ensure_warp
if "%choice%"=="8" goto restart_adapters
if "%choice%"=="9" goto test_connectivity
if "%choice%"=="10" goto run_all
if "%choice%"=="11" exit
goto menu

:flush_dns
echo Flushing DNS cache... >> %LOGFILE%
echo Flushing DNS cache...
ipconfig /flushdns 2>&1 >> %LOGFILE%
echo DNS cache flushed.
echo DNS cache flushed.
pause
goto menu

:reset_winsock
echo Resetting Winsock... >> %LOGFILE%
echo Resetting Winsock...
netsh winsock reset 2>&1 >> %LOGFILE%
echo Winsock reset. Please restart your computer for changes to take effect.
echo Winsock reset. Please restart your computer for changes to take effect.
pause
goto menu

:reset_ipv4
echo Resetting IPv4 TCP/IP stack... >> %LOGFILE%
echo Resetting IPv4 TCP/IP stack...
netsh int ip reset 2>&1 >> %LOGFILE%
echo IPv4 TCP/IP stack reset. Please restart your computer for changes to take effect.
echo IPv4 TCP/IP stack reset. Please restart your computer for changes to take effect.
pause
goto menu

:reset_ipv6
echo Resetting IPv6 TCP/IP stack... >> %LOGFILE%
echo Resetting IPv6 TCP/IP stack...
netsh int ipv6 reset 2>&1 >> %LOGFILE%
echo IPv6 TCP/IP stack reset. Please restart your computer for changes to take effect.
echo IPv6 TCP/IP stack reset. Please restart your computer for changes to take effect.
pause
goto menu

:clear_arp
echo Clearing ARP cache... >> %LOGFILE%
echo Clearing ARP cache...
arp -d * 2>&1 >> %LOGFILE%
echo ARP cache cleared.
echo ARP cache cleared.
pause
goto menu

:restart_services
echo Restarting DHCP and DNS Client services... >> %LOGFILE%
echo Restarting DHCP and DNS Client services...
net stop dhcp 2>&1 >> %LOGFILE%
net start dhcp 2>&1 >> %LOGFILE%
net stop dnscache 2>&1 >> %LOGFILE%
net start dnscache 2>&1 >> %LOGFILE%
echo DHCP and DNS Client services restarted.
echo DHCP and DNS Client services restarted.
pause
goto menu

:ensure_warp
echo Ensuring Cloudflare WARP service is running... >> %LOGFILE%
echo Ensuring Cloudflare WARP service is running...
net start "Cloudflare WARP" 2>&1 >> %LOGFILE%
if errorlevel 1 (
    echo Cloudflare WARP service failed to start or is already running. >> %LOGFILE%
    echo Cloudflare WARP service failed to start or is already running.
) else (
    echo Cloudflare WARP service is running. >> %LOGFILE%
    echo Cloudflare WARP service is running.
)
pause
goto menu

:restart_adapters
echo Restarting network adapters... >> %LOGFILE%
echo Restarting network adapters...
for /f "tokens=*" %%A in ('netsh interface show interface ^| findstr /C:"Enabled"') do (
    echo Disabling adapter: %%A >> %LOGFILE%
    echo Disabling adapter: %%A
    netsh interface set interface name="%%A" admin=disable 2>&1 >> %LOGFILE%
    netsh interface set interface name="%%A" admin=disable
    timeout /t 2 >nul
    echo Enabling adapter: %%A >> %LOGFILE%
    echo Enabling adapter: %%A
    netsh interface set interface name="%%A" admin=enable 2>&1 >> %LOGFILE%
    netsh interface set interface name="%%A" admin=enable
)
echo Network adapters restarted.
echo Network adapters restarted.
pause
goto menu

:test_connectivity
echo Please enter the Minecraft server IP: 
set /p server_ip=Server IP: 
echo Testing connectivity to Minecraft server: %server_ip% >> %LOGFILE%
echo Testing connectivity to Minecraft server: %server_ip%
ping %server_ip% -n 4 2>&1 >> %LOGFILE%
ping %server_ip% -n 4
pause
goto menu

:run_all
call :flush_dns
call :reset_winsock
call :reset_ipv4
call :reset_ipv6
call :clear_arp
call :restart_services
call :ensure_warp
call :restart_adapters
call :test_connectivity
goto menu