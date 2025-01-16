import subprocess
import tkinter as tk
from tkinter import scrolledtext
import logging
from datetime import datetime
import os

# Create logs directory if it doesn't exist
if not os.path.exists("logs"):
    os.makedirs("logs")

# Configure logging with a unique filename for each session
log_filename = datetime.now().strftime("logs/%Y_%m_%d-%H_%M_%S.log")
logging.basicConfig(
    filename=log_filename,
    level=logging.DEBUG,  # Set to DEBUG to capture detailed logs
    format="%(asctime)s - %(levelname)s - %(message)s",
)


# Function to execute a command and show the output
def execute_command(command, success_message, clear_log=False):
    logging.debug(f"Executing command: {command}")
    try:
        if clear_log:
            log_text.delete(1.0, tk.END)
        result = subprocess.Popen(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            stdin=subprocess.PIPE,
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
            logging.error(error_message)
    except Exception as e:
        error_message = str(e)
        log_output(error_message)
        logging.error(error_message)


# Function to log output to the text box and file
def log_output(output):
    log_text.insert(tk.END, output + "\n")
    log_text.see(tk.END)
    logging.info(output)


# Function to handle user input in the text box
def on_enter(event):
    user_input = log_text.get("end-2c linestart", "end-1c").strip()
    log_text.insert(tk.END, "\n")
    log_text.see(tk.END)
    if user_input.startswith("Enter IP to ping:"):
        ip_address = user_input.split(":")[1].strip()
        logging.debug(f"Extracted IP address: {ip_address}")
        if ip_address:
            execute_command(
                f"ping {ip_address} -n 4", f"Ping to {ip_address} complete."
            )
        else:
            log_output("Invalid IP address.")
            logging.error("Invalid IP address.")
    else:
        execute_command(user_input, "", clear_log=False)


# Command functions
def flush_dns():
    execute_command("ipconfig /flushdns", "DNS cache flushed successfully.")


def clear_arp():
    execute_command("arp -d", "ARP cache cleared successfully.")


def test_connectivity():
    show_test_connectivity_menu()


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


def display_network_config():
    execute_command("ipconfig /all", "Network configuration displayed.")


def check_driver_updates():
    execute_command(
        "wmic path win32_pnpentity where \"DeviceID like '%%PCI%%'\" get DeviceID, Name, Manufacturer, DriverVersion",
        "Network driver updates check completed.",
    )


def show_help(command, description):
    execute_command(f"{command} /?", description, clear_log=True)


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
sidebar_frame = tk.Frame(paned_window, bg="#2e2e2e", width=300)
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
    paned_window,
    width=80,
    height=40,
    bg="#1e1e1e",
    fg="#ffffff",
    font=("Arial", 10),
    insertbackground="white",
)
paned_window.add(log_text)
log_text.bind("<Return>", on_enter)

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


# Function to switch to the test connectivity menu
def show_test_connectivity_menu():
    clear_buttons()
    menu_title.config(text="Test Connectivity")
    add_buttons(test_connectivity_buttons)


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
    ("Display Network Configuration", display_network_config),
    ("Check for Network Driver Updates", check_driver_updates),
    ("Help", show_help_menu),
]

# Help menu buttons
help_menu_buttons = [
    ("Flush DNS", lambda: show_help("ipconfig /flushdns", "Flush DNS Cache")),
    ("Clear ARP", lambda: show_help("arp -d", "Clear ARP Cache")),
    ("Ping", lambda: show_help("ping", "Test Connectivity")),
    ("Display DNS", lambda: show_help("ipconfig /displaydns", "Display DNS Cache")),
    (
        "Reset Network",
        lambda: show_help("netsh int ip reset", "Reset Network Settings"),
    ),
    (
        "Release/Renew IP",
        lambda: show_help(
            "ipconfig /release && ipconfig /renew", "Release and Renew IP Address"
        ),
    ),
    (
        "Check Adapter",
        lambda: show_help(
            "netsh interface show interface", "Check Network Adapter Status"
        ),
    ),
    ("Reset Winsock", lambda: show_help("netsh winsock reset", "Reset Winsock")),
    (
        "Reset IPv4",
        lambda: show_help("netsh int ip reset", "Reset TCP/IP Stack (IPv4)"),
    ),
    (
        "Reset IPv6",
        lambda: show_help("netsh int ipv6 reset", "Reset TCP/IP Stack (IPv6)"),
    ),
    (
        "Restart Services",
        lambda: show_help(
            "net stop dhcp && net start dhcp && net stop dnscache && net start dnscache",
            "Restart DHCP and DNS Client Services",
        ),
    ),
    (
        "Restart Adapters",
        lambda: show_help(
            'netsh interface set interface name="[Adapter Name]" admin=disable && netsh interface set interface name="[Adapter Name]" admin=enable',
            "Restart Network Adapters",
        ),
    ),
    (
        "Check Internet",
        lambda: show_help("ping www.google.com", "Check Internet Connectivity"),
    ),
    (
        "Display Config",
        lambda: show_help("ipconfig /all", "Display Network Configuration"),
    ),
    (
        "Check Drivers",
        lambda: show_help(
            "wmic path win32_pnpentity where \"DeviceID like '%%PCI%%'\" get DeviceID, Name, Manufacturer, DriverVersion",
            "Check for Network Driver Updates",
        ),
    ),
    ("Back to Main Menu", show_main_menu),
]

# Test connectivity menu buttons
test_connectivity_buttons = [
    (
        "Ping Google DNS (8.8.8.8)",
        lambda: execute_command("ping 8.8.8.8 -n 4", "Ping to Google DNS complete."),
    ),
    (
        "Ping Cloudflare DNS (1.1.1.1)",
        lambda: execute_command(
            "ping 1.1.1.1 -n 4", "Ping to Cloudflare DNS complete."
        ),
    ),
    (
        "Ping OpenDNS (208.67.222.222)",
        lambda: execute_command(
            "ping 208.67.222.222 -n 4", "Ping to OpenDNS complete."
        ),
    ),
    ("Enter Custom IP", lambda: log_text.insert(tk.END, "Enter IP to ping: ")),
    ("Back to Main Menu", show_main_menu),
]

# Show the main menu initially
show_main_menu()

# Run the GUI loop
root.mainloop()
