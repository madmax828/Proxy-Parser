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
echo "" 

# Define temporary runtime workspace files
temp_raw_list="/tmp/raw_proxies.txt"
temp_clean_list="/tmp/clean_proxies.txt"

# 1. Ask user for data sourcing method
echo "Select proxy sourcing method:"
echo " 1) Download fresh proxies from ProxyScrape API"
echo " 2) Parse an existing local file list"
echo -n "Choose an option (1 or 2): "
read -r source_choice

if [ "$source_choice" = "1" ]; then
    echo "Fetching proxies from ProxyScrape API..."
    # Execute the curl request
    curl -s --request GET --url 'https://proxyscrape.com' -o "$temp_raw_list"
    
    if [ ! -s "$temp_raw_list" ]; then
        echo "Error: API download failed or returned an empty file!"
        exit 1
    fi
    echo "Download complete!"
    input_file="$temp_raw_list"
elif [ "$source_choice" = "2" ]; then
    echo -n "Enter the path to your input proxy file: "
    read -r input_file
    if [ ! -f "$input_file" ]; then
        echo "Error: File '$input_file' does not exist!"
        exit 1
    fi
else
    echo "Invalid choice. Exiting script."
    exit 1
fi

# FIX: Strip Windows line endings (\r) and save to a clean temporary file
tr -d '\r' < "$input_file" > "$temp_clean_list"

# 2. Get the config file path (Defaults to /etc/proxychains4.conf)
echo -n "Enter the path to the conf file [/etc/proxychains4.conf]: "
read -r conf_file
if [ -z "$conf_file" ]; then
    conf_file="/etc/proxychains4.conf"
fi

# 3. Get the number of proxies to add
echo -n "How many proxies do you want to add? "
read -r proxy_count

# Validate numbers
if ! [[ "$proxy_count" =~ ^[0-9]+$ ]] || [ "$proxy_count" -le 0 ]; then
    echo "Error: Please enter a valid number greater than 0."
    exit 1
fi

# 4. Check boundaries using our clean file
total_lines=$(wc -l < "$temp_clean_list")
if [ "$proxy_count" -gt "$total_lines" ]; then
    echo "Warning: You requested $proxy_count proxies, but only $total_lines exist. Appending all available."
    proxy_count=$total_lines
fi

# 5. Process formatting, limit output counts, and clean append
echo "" >> "$conf_file"
head -n "$proxy_count" "$temp_clean_list" | sed -E 's|://| |g; s|:| |g' >> "$conf_file"

# Cleanup temporary files
[ -f "$temp_raw_list" ] && rm "$temp_raw_list"
[ -f "$temp_clean_list" ] && rm "$temp_clean_list"

# Execution Confirmation Messages
echo ""
echo -e "\e[36mOK! WE ARE READY TO USE SOME PROXY-FU AND DISAPPEAR IN THE NOISE! 🥋🥷💨\e[0m"
echo -e "\e[32mSuccess! Appended $proxy_count formatted proxies to: $conf_file ✅\e[0m"
