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


# Function to execute a command and show the output
def execute_command(command, success_message, clear_log=False):
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
        output, error = result.communicate()
        log_output(output)
        if result.returncode == 0:
            log_output(success_message)
        else:
            error_message = f"Command failed with error:\n{error}"
            log_output(error_message)
            logging.error(error_message)
    except Exception as e:
        error_message = str(e)
        log_output(error_message)
        logging.error(error_message)
    log_output("=" * 80)  # Add thick horizontal line separator after command execution


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


# Function to show command description and execution button
def show_command_description(description, command, success_message):
    logging.debug(f"Showing command: {description}, {command}, {success_message}")
    description_label.config(text=description)
    logging.debug(f"Updated description_label: {description}")
    execute_button.config(command=lambda: execute_command(command, success_message))
    logging.debug(f"Updated execute_button with command: {command}")


# Function to show a submenu
def show_submenu(submenu_name):
    logging.debug(f"Showing submenu: {submenu_name}")
    clear_buttons()
    log_text.delete(1.0, tk.END)  # Clear the screen
    menu_title.config(text=submenu_name.replace("_", " ").title())
    add_buttons(getattr(menu_items, submenu_name))


# Function to increase font size
def increase_font_size(event):
    current_size = log_text.cget("font").split()[1]
    new_size = int(current_size) + 2
    log_text.config(font=("Arial", new_size))
    menu_title.config(font=("Arial", new_size))
    update_button_fonts(new_size)


# Function to decrease font size
def decrease_font_size(event):
    current_size = log_text.cget("font").split()[1]
    new_size = int(current_size) - 2
    log_text.config(font=("Arial", new_size))
    menu_title.config(font=("Arial", new_size))
    update_button_fonts(new_size)


# Function to update button fonts
def update_button_fonts(size):
    for widget in buttons_frame.winfo_children():
        if isinstance(widget, tk.Button):
            widget.config(font=("Arial", size))


# Function to dynamically set the size of the buttons frame
def update_buttons_frame_size():
    buttons_frame.update_idletasks()
    width = max(button.winfo_reqwidth() for button in buttons_frame.winfo_children())
    height = sum(button.winfo_reqheight() for button in buttons_frame.winfo_children())
    buttons_frame.config(width=width, height=height)
    sidebar_canvas.config(scrollregion=sidebar_canvas.bbox("all"))


# Function to clear all buttons except the menu title
def clear_buttons():
    logging.debug("Clearing buttons")
    for widget in buttons_frame.winfo_children():
        if widget != menu_title:
            widget.destroy()


# Function to add buttons to the sidebar
def add_buttons(buttons):
    logging.debug(f"Adding buttons: {buttons}")
    for item in buttons:
        logging.debug(f"Adding button: {item['text']}")
        btn = tk.Button(
            buttons_frame,
            text=item["text"],
            command=lambda item=item: (
                show_command_description(
                    item["description"], item["command"], item["success_message"]
                )
                if "command" in item
                else lambda: show_submenu(item["submenu"])
            ),
            width=25,
            wraplength=200,  # Enable text wrapping
            **style,
        )
        btn.pack(pady=5, fill=tk.X, expand=True)
        btn.bind(
            "<Button-1>",
            lambda event, item=item: logging.debug(f"Button clicked: {item['text']}"),
        )
    update_buttons_frame_size()


# Function to execute a sequence of commands
def execute_sequence(commands):
    for command in commands:
        logging.debug(f"Executing sequence command: {command['command']}")
        execute_command(command["command"], command["success_message"])


# GUI setup
root = tk.Tk()
root.title("some network thing idk")
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

# Sidebar frame with scrollbar
sidebar_frame = tk.Frame(
    paned_window, bg="#ff0000", width=200
)  # Red background for debugging
paned_window.add(sidebar_frame, minsize=200)

# Scrollbar for sidebar
sidebar_scrollbar = tk.Scrollbar(sidebar_frame)
sidebar_scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

# Canvas for sidebar buttons
sidebar_canvas = tk.Canvas(
    sidebar_frame,
    bg="#00ff00",
    yscrollcommand=sidebar_scrollbar.set,  # Green background for debugging
)
sidebar_canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

# Frame for buttons inside the canvas
buttons_frame = tk.Frame(sidebar_canvas, bg="#0000ff")  # Blue background for debugging
sidebar_canvas.create_window((0, 0), window=buttons_frame, anchor="nw")

# Configure scrollbar
sidebar_scrollbar.config(command=sidebar_canvas.yview)

# Update scroll region
buttons_frame.bind(
    "<Configure>",
    lambda e: sidebar_canvas.configure(scrollregion=sidebar_canvas.bbox("all")),
)

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
bottom_frame = tk.Frame(root, bg="#2e2e2e")
bottom_frame.pack(fill=tk.X, side=tk.BOTTOM)

description_label = tk.Label(
    bottom_frame, text="", font=("Arial", 12), bg="#2e2e2e", fg="#ffffff"
)
description_label.pack(side=tk.LEFT, padx=10, pady=10)

execute_button = tk.Button(
    bottom_frame, text="Execute", font=("Arial", 12), bg="#1e1e1e", fg="#ffffff"
)
execute_button.pack(side=tk.RIGHT, padx=10, pady=10)

# Menu title
menu_title = tk.Label(buttons_frame, text="Main Menu", font=("Arial", 16), **style)
menu_title.pack(pady=10)


# Function to switch to the main menu
def show_main_menu():
    logging.debug("Showing main menu")
    show_submenu("main_menu")


# Show the main menu initially
show_main_menu()

# Bind font size increase and decrease to Ctrl + and Ctrl -
root.bind("<Control-=>", increase_font_size)
root.bind("<Control-minus>", decrease_font_size)

# Run the GUI loop
root.mainloop()
