# ░█▀█░█▀▄░█▀█░█░█░█▀█░█▀▄░█▀▄
# ░█▀▀░█▀▄░█░█░▄▀▄░█▀█░█░█░█░█
# ░▀░░░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀░░▀▀░
# ░░░░░░░░                    
# ░░░░░░░░                    

# Proxychains Aggregator (proxadd.sh)

A lightweight interactive automation script designed to dynamically fetch or parse raw proxy lists, clean-format them, and seamlessly inject them directly into Proxychains configuration profiles.

Developed by **MaDMaX**  
**Version:** 1.0  
**Release:** June 2026  

---

## 📌 Purpose

Proxychains requires proxy entries to be space-separated columns at the bottom of its configuration file:
`socks5 72.56.80.241 1080`

However, public scraping APIs or raw downloads often output them as standard web URLs:
`socks5://72.56.80.241:1080`

`proxadd.sh` bridges this gap completely. It offers an automated way to pull a live list straight from an API or take your own local text dump, automatically strip the delimiters, and cleanly write the exact quantity you request to your configuration setup.

---

## ⚙️ Features

* **Dual-Input Sourcing Engine:**
  * **Option 1:** Pulls up to 2,000 live, multi-protocol proxies directly from the **ProxyScrape API** via a single terminal tap.
  * **Option 2:** Loads and parses an existing local raw text file stored on your machine.
* **Smart Path Mapping:** Pressing `Enter` automatically assigns the standard path target `/etc/proxychains4.conf`.
* **Precision Injections:** Lets you choose exactly how many lines from the top of the file to feed into your active profile.
* **Automated Housekeeping:** Deletes downloaded transient payloads from temporary directories (`/tmp/`) as soon as the target configuration file updates.
* **Custom Interactive Interface:** Includes a custom terminal workspace clear command, a signature ASCII art presentation header, and vibrant ANSI visual status tags.

---

## 🚀 How To Use

### 1. Make the Script Executable
Clone or download `proxadd.sh` onto your system, navigate to its directory in your terminal, and run:
```bash
chmod +x proxadd.sh
```

### 2. Run the Script
Because Proxychains configuration profiles reside inside protected administrative folders (`/etc/`), execute the script with root privileges:
```bash
sudo ./proxadd.sh
```

### 3. Step-by-Step Flow
1. **Choose Sourcing:** Press `1` to instantly query ProxyScrape API servers, or press `2` to supply a path to your own proxy text dump.
2. **Configuration Target:** Type your custom config path, or simply hit `Enter` to use the `/etc/proxychains4.conf` default.
3. **Quantity Selection:** Type the total count of proxies you want to append.

The script will instantly download, reformat, write the lines, scrub its temporary work files, and notify you that you are ready for action!

---

## 📝 License & Contributions
Created for personal utility, speed optimization, and workflow refinement. Feel free to clone, edit the regular expressions, change API endpoints, or modify default settings to suit your target environment.
