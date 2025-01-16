import subprocess
import tkinter as tk
from tkinter import scrolledtext
import logging

# Configure logging
logging.basicConfig(
    filename="network_troubleshooting.log",
    level=logging.INFO,
    format="%(asctime)s - %(message)s",
)


# Function to execute a command and show the output
def execute_command(command, success_message):
    try:
        result = subprocess.Popen(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            shell=True,
        )
        output = ""
        for line in result.stdout:
            output += line
            log_output(line)
        result.wait()
        if result.returncode == 0:
            log_output(success_message)
        else:
            error_message = f"Command failed with error:\n{result.stderr.read()}"
            log_output(error_message)
    except Exception as e:
        error_message = str(e)
        log_output(error_message)


# Function to log output to the text box and file
def log_output(output):
    log_text.insert(tk.END, output + "\n")
    log_text.see(tk.END)
    logging.info(output)


# Command functions
def flush_dns():
    execute_command("ipconfig /flushdns", "DNS cache flushed successfully.")


def clear_arp():
    execute_command("arp -d", "ARP cache cleared successfully.")


def test_connectivity():
    execute_command("ping 8.8.8.8 -n 4", "Connectivity test complete.")


def display_dns():
    execute_command("ipconfig /displaydns", "DNS cache displayed.")


def reset_network():
    execute_command("netsh int ip reset", "Network settings reset successfully.")


def release_renew_ip():
    execute_command(
        "ipconfig /release && ipconfig /renew", "IP address released and renewed."
    )


def check_adapter_status():
    execute_command(
        "netsh interface show interface", "Network adapter status displayed."
    )


def reset_winsock():
    execute_command(
        "netsh winsock reset",
        "Winsock reset successfully. Please restart your computer for changes to take effect.",
    )


def reset_ipv4():
    execute_command(
        "netsh int ip reset",
        "IPv4 TCP/IP stack reset successfully. Please restart your computer for changes to take effect.",
    )


def reset_ipv6():
    execute_command(
        "netsh int ipv6 reset",
        "IPv6 TCP/IP stack reset successfully. Please restart your computer for changes to take effect.",
    )


def restart_services():
    execute_command(
        "net stop dhcp && net start dhcp && net stop dnscache && net start dnscache",
        "DHCP and DNS Client services restarted.",
    )


def restart_adapters():
    execute_command(
        'for /f "tokens=*" %%A in (\'netsh interface show interface ^| findstr /C:"Enabled"\') do (netsh interface set interface name="%%A" admin=disable && timeout /t 2 >nul && netsh interface set interface name="%%A" admin=enable)',
        "Network adapters restarted.",
    )


def check_internet_connectivity():
    execute_command("ping www.google.com", "Internet connectivity check completed.")


def display_network_config():
    execute_command("ipconfig /all", "Network configuration displayed.")


def check_driver_updates():
    execute_command(
        "wmic path win32_pnpentity where \"DeviceID like '%%PCI%%'\" get DeviceID, Name, Manufacturer, DriverVersion",
        "Network driver updates check completed.",
    )


def show_help(command, description):
    execute_command(f"{command} /?", description)


# GUI setup
root = tk.Tk()
root.title("Network Troubleshooting Menu")
root.geometry("1200x800")  # Landscape resolution

# Apply dark mode
root.configure(bg="#2e2e2e")
style = {
    "bg": "#2e2e2e",
    "fg": "#ffffff",
    "highlightbackground": "#2e2e2e",
    "highlightcolor": "#2e2e2e",
}

# Paned window for resizable sidebar
paned_window = tk.PanedWindow(root, orient=tk.HORIZONTAL, bg="#2e2e2e")
paned_window.pack(fill=tk.BOTH, expand=True)

# Sidebar frame
sidebar_frame = tk.Frame(paned_window, bg="#2e2e2e", width=200)
paned_window.add(sidebar_frame)

# Scrollbar for sidebar
sidebar_scrollbar = tk.Scrollbar(sidebar_frame)
sidebar_scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

# Canvas for sidebar buttons
sidebar_canvas = tk.Canvas(
    sidebar_frame, bg="#2e2e2e", yscrollcommand=sidebar_scrollbar.set
)
sidebar_canvas.pack(side=tk.LEFT, fill=tk.Y, expand=True)

# Frame for buttons inside the canvas
buttons_frame = tk.Frame(sidebar_canvas, bg="#2e2e2e")
sidebar_canvas.create_window((0, 0), window=buttons_frame, anchor="nw")

# Configure scrollbar
sidebar_scrollbar.config(command=sidebar_canvas.yview)


# Update scroll region
def on_configure(event):
    sidebar_canvas.configure(scrollregion=sidebar_canvas.bbox("all"))


buttons_frame.bind("<Configure>", on_configure)

# Text box for logging
log_text = scrolledtext.ScrolledText(
    paned_window, width=100, height=40, bg="#1e1e1e", fg="#ffffff", font=("Arial", 10)
)
paned_window.add(log_text)

# Menu title
menu_title = tk.Label(buttons_frame, text="Main Menu", font=("Arial", 16), **style)
menu_title.pack(pady=10)


# Function to switch to the main menu
def show_main_menu():
    clear_buttons()
    menu_title.config(text="Main Menu")
    add_buttons(main_menu_buttons)


# Function to switch to the help menu
def show_help_menu():
    clear_buttons()
    menu_title.config(text="Help Menu")
    add_buttons(help_menu_buttons)


# Function to clear all buttons except the menu title
def clear_buttons():
    for widget in buttons_frame.winfo_children():
        if widget != menu_title:
            widget.destroy()


# Function to add buttons to the sidebar
def add_buttons(buttons):
    for text, command in buttons:
        btn = tk.Button(buttons_frame, text=text, command=command, width=30, **style)
        btn.pack(pady=5)


# Main menu buttons
main_menu_buttons = [
    ("Flush DNS Cache", flush_dns),
    ("Clear ARP Cache", clear_arp),
    ("Test Connectivity", test_connectivity),
    ("Display DNS Cache", display_dns),
    ("Reset Network Settings", reset_network),
    ("Release and Renew IP Address", release_renew_ip),
    ("Check Network Adapter Status", check_adapter_status),
    ("Reset Winsock", reset_winsock),
    ("Reset TCP/IP Stack (IPv4)", reset_ipv4),
    ("Reset TCP/IP Stack (IPv6)", reset_ipv6),
    ("Restart DHCP and DNS Client Services", restart_services),
    ("Restart Network Adapters", restart_adapters),
    ("Check Internet Connectivity", check_internet_connectivity),
    ("Display Network Configuration", display_network_config),
    ("Check for Network Driver Updates", check_driver_updates),
    ("Help", show_help_menu),
]

# Help menu buttons
help_menu_buttons = [
    ("Flush DNS Cache", lambda: show_help("ipconfig /flushdns", "Flush DNS Cache")),
    ("Clear ARP Cache", lambda: show_help("arp -d", "Clear ARP Cache")),
    ("Test Connectivity", lambda: show_help("ping", "Test Connectivity")),
    (
        "Display DNS Cache",
        lambda: show_help("ipconfig /displaydns", "Display DNS Cache"),
    ),
    (
        "Reset Network Settings",
        lambda: show_help("netsh int ip reset", "Reset Network Settings"),
    ),
    (
        "Release and Renew IP Address",
        lambda: show_help(
            "ipconfig /release && ipconfig /renew", "Release and Renew IP Address"
        ),
    ),
    (
        "Check Network Adapter Status",
        lambda: show_help(
            "netsh interface show interface", "Check Network Adapter Status"
        ),
    ),
    ("Reset Winsock", lambda: show_help("netsh winsock reset", "Reset Winsock")),
    (
        "Reset TCP/IP Stack (IPv4)",
        lambda: show_help("netsh int ip reset", "Reset TCP/IP Stack (IPv4)"),
    ),
    (
        "Reset TCP/IP Stack (IPv6)",
        lambda: show_help("netsh int ipv6 reset", "Reset TCP/IP Stack (IPv6)"),
    ),
    (
        "Restart DHCP and DNS Client Services",
        lambda: show_help(
            "net stop dhcp && net start dhcp && net stop dnscache && net start dnscache",
            "Restart DHCP and DNS Client Services",
        ),
    ),
    (
        "Restart Network Adapters",
        lambda: show_help(
            'netsh interface set interface name="[Adapter Name]" admin=disable && netsh interface set interface name="[Adapter Name]" admin=enable',
            "Restart Network Adapters",
        ),
    ),
    (
        "Check Internet Connectivity",
        lambda: show_help("ping www.google.com", "Check Internet Connectivity"),
    ),
    (
        "Display Network Configuration",
        lambda: show_help("ipconfig /all", "Display Network Configuration"),
    ),
    (
        "Check for Network Driver Updates",
        lambda: show_help(
            "wmic path win32_pnpentity where \"DeviceID like '%%PCI%%'\" get DeviceID, Name, Manufacturer, DriverVersion",
            "Check for Network Driver Updates",
        ),
    ),
    ("Back to Main Menu", show_main_menu),
]

# Show the main menu initially
root.after(0, show_main_menu)

# Run the GUI loop
root.mainloop()
