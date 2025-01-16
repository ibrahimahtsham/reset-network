import subprocess
import tkinter as tk
from tkinter import scrolledtext
import logging
from datetime import datetime
import os
import menu_items

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


def execute_command(command, success_message, clear_log=False):
    """Execute a command and show the output."""
    log_output("=" * 80)  # Add thick horizontal line separator before command execution
    logging.debug(f"Executing command: {command}")
    log_output(f"Executing command: {command}")
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
    log_output("=" * 80)  # Add thick horizontal line separator after command execution


def log_output(output):
    """Log output to the text box and file."""
    log_text.insert(tk.END, output + "\n")
    log_text.see(tk.END)
    logging.info(output)


def on_enter(event):
    """Handle user input in the text box."""
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


def show_command_description(description, command, success_message, long_description):
    """Show command description and execution button."""
    logging.debug(
        f"Showing command: {description}, {command}, {success_message}, {long_description}"
    )
    description_label.config(
        text=f"{description}\n\n{command}\n\n{long_description}",
        anchor="w",
        justify="left",
    )
    logging.debug(f"Updated description_label: {description}")
    execute_button.config(command=lambda: execute_command(command, success_message))
    logging.debug(f"Updated execute_button with command: {command}")


def show_submenu(submenu_name):
    """Show a submenu."""
    logging.debug(f"Showing submenu: {submenu_name}")
    clear_buttons()
    log_text.delete(1.0, tk.END)  # Clear the screen
    menu_title.config(text=submenu_name.replace("_", " ").title())
    add_buttons(getattr(menu_items, submenu_name))


def increase_font_size(event):
    """Increase font size."""
    update_font_size(2)


def decrease_font_size(event):
    """Decrease font size."""
    update_font_size(-2)


def update_font_size(delta):
    """Update font size."""
    current_size = int(log_text.cget("font").split()[1])
    new_size = current_size + delta
    log_text.config(font=("Arial", new_size))
    menu_title.config(font=("Arial", new_size))
    update_button_fonts(new_size)


def update_button_fonts(size):
    """Update button fonts."""
    for widget in sidebar_frame.winfo_children():
        if isinstance(widget, tk.Button):
            widget.config(font=("Arial", size))


# GUI setup
root = tk.Tk()
root.title("Network Troubleshooting Menu")
root.geometry("1200x800")  # Landscape resolution
root.configure(bg="#2e2e2e", padx=10, pady=10)  # Apply dark mode and padding

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

# Text box for logging
log_text = scrolledtext.ScrolledText(
    paned_window,
    width=80,
    height=30,
    bg="#1e1e1e",
    fg="#ffffff",
    font=("Arial", 10),
    insertbackground="white",
)
paned_window.add(log_text)
log_text.bind("<Return>", on_enter)

# Bottom frame for command description and execution button
bottom_frame = tk.Frame(root, bg="#2e2e2e", padx=10, pady=10)
bottom_frame.pack(fill=tk.X, side=tk.BOTTOM, anchor="w")
bottom_frame.pack_propagate(False)

description_label = tk.Label(
    bottom_frame,
    text="",
    font=("Arial", 12),
    bg="#2e2e2e",
    fg="#ffffff",
    anchor="w",
    justify="left",
)
description_label.pack(side=tk.LEFT, padx=10, pady=10, fill=tk.BOTH, expand=True)

execute_button = tk.Button(
    bottom_frame, text="Execute", font=("Arial", 12), bg="#1e1e1e", fg="#ffffff"
)
execute_button.pack(side=tk.RIGHT, padx=10, pady=10)

# Menu title
menu_title = tk.Label(sidebar_frame, text="Main Menu", font=("Arial", 16), **style)
menu_title.pack(pady=10)


def show_main_menu():
    """Switch to the main menu."""
    logging.debug("Showing main menu")
    show_submenu("main_menu")


def clear_buttons():
    """Clear all buttons except the menu title."""
    logging.debug("Clearing buttons")
    for widget in sidebar_frame.winfo_children():
        if widget != menu_title:
            widget.destroy()


def add_buttons(buttons):
    """Add buttons to the sidebar."""
    logging.debug(f"Adding buttons: {buttons}")
    for item in buttons:
        logging.debug(f"Adding button: {item['text']}")
        btn = tk.Button(
            sidebar_frame,
            text=item["text"],
            wraplength=200,
            **style,
        )
        btn.pack(pady=5, fill=tk.X, anchor="n")
        btn.bind(
            "<Configure>",
            lambda event, btn=btn: btn.config(wraplength=btn.winfo_width() - 10),
        )
        if "submenu" in item:
            btn.config(command=lambda submenu=item["submenu"]: show_submenu(submenu))
        elif "custom_input" in item:
            btn.config(command=lambda: log_text.insert(tk.END, "Enter IP to ping: "))
        elif "commands" in item:
            btn.config(
                command=lambda: show_command_description(
                    item["description"],
                    "\n".join([cmd["command"] for cmd in item["commands"]]),
                    "\n".join([cmd["success_message"] for cmd in item["commands"]]),
                    item.get("long_description", ""),
                )
            )
        else:
            btn.config(
                command=lambda item=item: show_command_description(
                    item["description"],
                    item["command"],
                    item["success_message"],
                    item.get("long_description", ""),
                )
            )
        btn.bind(
            "<Button-1>",
            lambda event, item=item: logging.debug(f"Button clicked: {item['text']}"),
        )


def execute_sequence(commands):
    """Execute a sequence of commands."""
    for command in commands:
        logging.debug(f"Executing sequence command: {command['command']}")
        execute_command(command["command"], command["success_message"])


# Show the main menu initially
show_main_menu()

# Bind font size increase and decrease to Ctrl + and Ctrl -
root.bind("<Control-=>", increase_font_size)
root.bind("<Control-minus>", decrease_font_size)

# Run the GUI loop
root.mainloop()
