# ░█▀█░█▀▄░█▀█░█░█░█▀█░█▀▄░█▀▄
# ░█▀▀░█▀▄░█░█░▄▀▄░█▀█░█░█░█░█
# ░▀░░░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀░░▀▀░
# ░░░░░░░░                    
# ░░░░░░░░                    

# Proxychains Aggregator (proxadd.sh)

A lightweight interactive automation script designed to parse, reformat, and cleanly append downloaded raw proxy lists directly into Proxychains configuration profiles. 

Developed by **MaDMaX**  
**Version:** 1.0  
**Release:** May 2026  

---

## 📌 Purpose

For free proxy downloads: https://proxyscrape.com/free-proxy-list 
When you download public or private proxy lists, they frequently come formatted as URLs:
`socks5://72.56.80.241:1080`

Proxychains requires proxy entries to be space-separated columns at the bottom of its configuration file:
`socks5 72.56.80.241 1080`

`proxadd.sh` eliminates manual editing by dynamically converting your raw list into the correct format, filtering the exact volume of proxies you want, and appending them to your configuration file automatically.

---

## ⚙️ Features

* **Interactive Prompting:** No hardcoded paths. The script dynamically asks you for file targets.
* **Smart Defaults:** Pressing `Enter` automatically maps to the standard `/etc/proxychains4.conf` path.
* **Volume Limiter:** Allows you to specify exactly how many fresh proxies from your list should be injected.
* **Bounds Protection:** Validates input parameters and ensures you do not request more proxies than your input file contains.

---

## 🚀 How To Use

### 1. Make the Script Executable
After cloning or downloading `proxadd.sh` to your system, navigate to its directory and grant execution permissions:
```bash
chmod +x proxadd.sh
```

### 2. Run the Script
Because Proxychains configuration files typically reside in the system-protected `/etc/` directory, run the script using `sudo`:
```bash
sudo ./proxadd.sh
```

### 3. Follow the Prompts
1. **Input Proxy File:** Type the path to your downloaded text file (e.g., `downloads/proxies.txt`).
2. **Configuration Target:** Type your proxychains path, or simply press `Enter` to use the default `/etc/proxychains4.conf`.
3. **Quantity Selection:** Type the total number of proxies you want to append.

---

## 📝 License & Contributions
Created for personal utility and workflow efficiency. Feel free to fork, adjust regular expressions, or modify the defaults to match your specific networking ecosystem.
