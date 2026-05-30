# Clear the screen first to make the banner pop
Clear-Host

# Display MaDMaX Version 1.0 Custom ASCII Banner
$banner = @"
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
"@

Write-Output $banner
Write-Output "" # Empty spacing line for clean layout

# 1. Get and validate the input proxy list
$inputFile = Read-Host "Enter the path to the input proxy file"

if (-not (Test-Path $inputFile)) {
    Write-Error "Error: File '$inputFile' does not exist!"
    return
}

# 2. Get the config file path (Defaults to /etc/proxychains4.conf on empty Enter)
$confFile = Read-Host "Enter the path to the conf file [Default: /etc/proxychains4.conf]"
if ([string]::IsNullOrWhiteSpace($confFile)) {
    $confFile = "/etc/proxychains4.conf"
}

# 3. Get the number of proxies to add
[string]$countInput = Read-Host "How many proxies do you want to add"
if (-not [int]::TryParse($countInput, [ref]$proxyCount) -or $proxyCount -le 0) {
    Write-Error "Error: Please enter a valid number greater than 0."
    return
}

# 4. Read the file lines and check availability
$proxies = Get-Content $inputFile
if ($proxyCount -gt $proxies.Count) {
    Write-Host "Warning: You requested $proxyCount proxies, but only $($proxies.Count) exist. Using all available proxies." -ForegroundColor Yellow
    $proxyCount = $proxies.Count
}

# 5. Process, format, limit count, and append to the configuration file
$formattedProxies = $proxies[0..($proxyCount - 1)] -replace '://', ' ' -replace ':', ' '

# Append to the file (adds an implicit newline buffer automatically)
$formattedProxies | Out-File -FilePath $confFile -Append -Encoding ascii
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Write-Host ""
Write-Host "OK! WE ARE READY TO USE SOME PROXY-FU AND DISAPPEAR IN THE NOISE! 🥋🥷💨" -ForegroundColor Cyan
Write-Host "Success! Appended $proxyCount formatted proxies to: $confFile ✅" -ForegroundColor Green
