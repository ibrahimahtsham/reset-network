main_menu = [
    {
        "text": "Flush DNS Cache",
        "description": "Flushes the DNS cache to resolve DNS-related issues.",
        "command": "ipconfig /flushdns",
        "success_message": "DNS cache flushed successfully.",
    },
    {
        "text": "Clear ARP Cache",
        "description": "Clears the ARP cache to resolve ARP-related issues.",
        "command": "arp -d",
        "success_message": "ARP cache cleared successfully.",
    },
    {
        "text": "Test Connectivity",
        "description": "Tests network connectivity by pinging common DNS servers.",
        "submenu": "test_connectivity",
    },
    {
        "text": "Display DNS Cache",
        "description": "Displays the current DNS cache entries.",
        "command": "ipconfig /displaydns",
        "success_message": "DNS cache displayed.",
    },
    {
        "text": "Reset Network Settings",
        "description": "Resets network settings to default.",
        "command": "netsh int ip reset",
        "success_message": "Network settings reset successfully.",
    },
    {
        "text": "Release and Renew IP Address",
        "description": "Releases and renews the IP address.",
        "command": "ipconfig /release && ipconfig /renew",
        "success_message": "IP address released and renewed.",
    },
    {
        "text": "Check Network Adapter Status",
        "description": "Displays the status of network adapters.",
        "command": "netsh interface show interface",
        "success_message": "Network adapter status displayed.",
    },
    {
        "text": "Reset Winsock",
        "description": "Resets Winsock settings. Requires a restart.",
        "command": "netsh winsock reset",
        "success_message": "Winsock reset successfully. Please restart your computer for changes to take effect.",
    },
    {
        "text": "Reset TCP/IP Stack (IPv4)",
        "description": "Resets the IPv4 TCP/IP stack. Requires a restart.",
        "command": "netsh int ip reset",
        "success_message": "IPv4 TCP/IP stack reset successfully. Please restart your computer for changes to take effect.",
    },
    {
        "text": "Reset TCP/IP Stack (IPv6)",
        "description": "Resets the IPv6 TCP/IP stack. Requires a restart.",
        "command": "netsh int ipv6 reset",
        "success_message": "IPv6 TCP/IP stack reset successfully. Please restart your computer for changes to take effect.",
    },
    {
        "text": "Restart DHCP and DNS Client Services",
        "description": "Restarts DHCP and DNS Client services.",
        "command": "net stop dhcp && net start dhcp && net stop dnscache && net start dnscache",
        "success_message": "DHCP and DNS Client services restarted.",
    },
    {
        "text": "Restart Network Adapters",
        "description": "Restarts network adapters.",
        "command": 'for /f "tokens=*" %%A in (\'netsh interface show interface ^| findstr /C:"Enabled"\') do (netsh interface set interface name="%%A" admin=disable && timeout /t 2 >nul && netsh interface set interface name="%%A" admin=enable)',
        "success_message": "Network adapters restarted.",
    },
    {
        "text": "Display Network Configuration",
        "description": "Displays the current network configuration.",
        "command": "ipconfig /all",
        "success_message": "Network configuration displayed.",
    },
    {
        "text": "Check for Network Driver Updates",
        "description": "Checks for updates to network drivers.",
        "command": "wmic path win32_pnpentity where \"DeviceID like '%%PCI%%'\" get DeviceID, Name, Manufacturer, DriverVersion",
        "success_message": "Network driver updates check completed.",
    },
    {"text": "Help", "submenu": "help_menu"},
    {
        "text": "Flush DNS, Clear ARP, and Test Connectivity",
        "description": "Flushes DNS, clears ARP, and tests connectivity.",
        "commands": [
            {
                "command": "ipconfig /flushdns",
                "success_message": "DNS cache flushed successfully.",
            },
            {"command": "arp -d", "success_message": "ARP cache cleared successfully."},
            {
                "command": "ping 8.8.8.8 -n 4",
                "success_message": "Ping to Google DNS complete.",
            },
        ],
    },
]

help_menu = [
    {
        "text": "Flush DNS",
        "description": "Flush DNS Cache",
        "command": "ipconfig /flushdns /?",
    },
    {"text": "Clear ARP", "description": "Clear ARP Cache", "command": "arp -d /?"},
    {"text": "Ping", "description": "Test Connectivity", "command": "ping /?"},
    {
        "text": "Display DNS",
        "description": "Display DNS Cache",
        "command": "ipconfig /displaydns /?",
    },
    {
        "text": "Reset Network",
        "description": "Reset Network Settings",
        "command": "netsh int ip reset /?",
    },
    {
        "text": "Release/Renew IP",
        "description": "Release and Renew IP Address",
        "command": "ipconfig /release && ipconfig /renew /?",
    },
    {
        "text": "Check Adapter",
        "description": "Check Network Adapter Status",
        "command": "netsh interface show interface /?",
    },
    {
        "text": "Reset Winsock",
        "description": "Reset Winsock",
        "command": "netsh winsock reset /?",
    },
    {
        "text": "Reset IPv4",
        "description": "Reset TCP/IP Stack (IPv4)",
        "command": "netsh int ip reset /?",
    },
    {
        "text": "Reset IPv6",
        "description": "Reset TCP/IP Stack (IPv6)",
        "command": "netsh int ipv6 reset /?",
    },
    {
        "text": "Restart Services",
        "description": "Restart DHCP and DNS Client Services",
        "command": "net stop dhcp && net start dhcp && net stop dnscache && net start dnscache /?",
    },
    {
        "text": "Restart Adapters",
        "description": "Restart Network Adapters",
        "command": 'netsh interface set interface name="[Adapter Name]" admin=disable && netsh interface set interface name="[Adapter Name]" admin=enable /?',
    },
    {
        "text": "Check Internet",
        "description": "Check Internet Connectivity",
        "command": "ping www.google.com /?",
    },
    {
        "text": "Display Config",
        "description": "Display Network Configuration",
        "command": "ipconfig /all /?",
    },
    {
        "text": "Check Drivers",
        "description": "Check for Network Driver Updates",
        "command": "wmic path win32_pnpentity where \"DeviceID like '%%PCI%%'\" get DeviceID, Name, Manufacturer, DriverVersion /?",
    },
    {"text": "Back to Main Menu", "submenu": "main_menu"},
]

test_connectivity = [
    {
        "text": "Ping Google DNS (8.8.8.8)",
        "description": "Pings Google DNS to test connectivity.",
        "command": "ping 8.8.8.8 -n 4",
        "success_message": "Ping to Google DNS complete.",
    },
    {
        "text": "Ping Cloudflare DNS (1.1.1.1)",
        "description": "Pings Cloudflare DNS to test connectivity.",
        "command": "ping 1.1.1.1 -n 4",
        "success_message": "Ping to Cloudflare DNS complete.",
    },
    {
        "text": "Ping OpenDNS (208.67.222.222)",
        "description": "Pings OpenDNS to test connectivity.",
        "command": "ping 208.67.222.222 -n 4",
        "success_message": "Ping to OpenDNS complete.",
    },
    {
        "text": "Enter Custom IP",
        "description": "Enter IP to ping:",
        "custom_input": True,
    },
    {"text": "Back to Main Menu", "submenu": "main_menu"},
]
