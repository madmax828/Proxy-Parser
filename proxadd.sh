#!/bin/bash

#  Takes downloaded proxy list from sites like
#  https://proxyscrape.com/free-proxy-list
#  It changes the format from the downloaded
#  format to the format you can add to proxychains.conf
#  
#  From : socks5://72.56.80.241:1080
#  To : socks5 72.56.80.241 1080

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
# Note: This might require 'sudo' permissions depending on where your conf file lives.
echo "" >> "$conf_file" # Adds a newline visual buffer to the end of the conf file
head -n "$proxy_count" "$input_file" | sed -E 's|://| |g; s|:| |g' >> "$conf_file"

echo "Success! Appended $proxy_count formatted proxies to: $conf_file"
