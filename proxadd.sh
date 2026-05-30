#!/bin/bash

# Clear the screen first to make the banner pop
clear

# Display MaDMaX Version 1.0 Custom ASCII Banner
cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════════╗
 ║                                                                           ║
 ║                                                                           ║
 ║                                                                           ║
 ║     ________                                            ___      ___      ║
 ║     `MMMMMMMb.                                          `MM      `MM      ║
 ║      MM    `Mb                                           MM       MM      ║
 ║      MM     MM ___  __   _____  ____   ___   ___     ____MM   ____MM      ║
 ║      MM     MM `MM 6MM  6MMMMMb `MM(   )P' 6MMMMb   6MMMMMM  6MMMMMM      ║
 ║      MM    .M9  MM69 " 6M'   `Mb `MM` ,P  8M'  `Mb 6M'  `MM 6M'  `MM      ║
 ║      MMMMMMM9'  MM'    MM     MM  `MM,P       ,oMM MM    MM MM    MM      ║
 ║      MM         MM     MM     MM   `MM.   ,6MM9'MM MM    MM MM    MM      ║
 ║      MM         MM     MM     MM   d`MM.  MM'   MM MM    MM MM    MM      ║
 ║      MM         MM     YM.   ,M9  d' `MM. MM.  ,MM YM.  ,MM YM.  ,MM      ║
 ║     _MM_       _MM_     YMMMMM9 _d_  _)MM_`YMMM9'Yb.YMMMMMM_ YMMMMMM_     ║
 ║                                                                           ║
 ║                   ___  _ _ .                                              ║
 ║                   |==]  Y  .                                              ║
 ║                              _  _ ____ ___  _  _ ____ _ _                 ║
 ║                              |\/| |--| |__> |\/| |--| _X_                 ║
 ║                                                                           ║
 ╚═══════════════════════════════════════════════════════════════════════════╝
EOF
echo "" # Empty spacing line for clean layout

# 1. Get and validate the input proxy list
echo -n "Enter the path to the input proxy file: "
read -r input_file

if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' does not exist!"
    exit 1
fi

# 2. Get the config file path (Defaults to /etc/proxychains4.conf on empty Enter)
echo -n "Enter the path to the conf file [/etc/proxychains4.conf]: "
read -r conf_file
if [ -z "$conf_file" ]; then
    conf_file="/etc/proxychains4.conf"
fi

# 3. Get the number of proxies to add
echo -n "How many proxies do you want to add? "
read -r proxy_count

# Validate that the input is a positive number
if ! [[ "$proxy_count" =~ ^[0-9]+$ ]] || [ "$proxy_count" -le 0 ]; then
    echo "Error: Please enter a valid number greater than 0."
    exit 1
fi

# 4. Check total lines in proxy file to ensure we don't request too many
total_lines=$(wc -l < "$input_file")
if [ "$proxy_count" -gt "$total_lines" ]; then
    echo "Warning: You requested $proxy_count proxies, but only $total_lines exist. Using all available proxies."
    proxy_count=$total_lines
fi

# 5. Process, format, limit count, and append to the configuration file
echo "" >> "$conf_file" # Adds a newline visual buffer to the end of the conf file
head -n "$proxy_count" "$input_file" | sed -E 's|://| |g; s|:| |g' >> "$conf_file"

# 5. Process, format, limit count, and append to the configuration file
echo "" >> "$conf_file" # Adds a newline visual buffer to the end of the conf file
head -n "$proxy_count" "$input_file" | sed -E 's|://| |g; s|:| |g' >> "$conf_file"
echo ""
echo -e "\e[36mOK! WE ARE READY TO USE SOME PROXY-FU AND DISAPPEAR IN THE NOISE! 🥋🥷💨\e[0m"
echo -e "\e[32mSuccess! Appended $proxyCount formatted proxies to: $conf_file ✅\e[0m"
