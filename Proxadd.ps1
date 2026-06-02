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
Write-Output ""

$tempRawList = "$env:TEMP\raw_proxies.txt"
$proxies = @()

# 1. Menu Selection Logic
Write-Host "Select proxy sourcing method:" -ForegroundColor Yellow
Write-Host " [1] Download fresh proxies from ProxyScrape API"
Write-Host " [2] Parse an existing local file list"
$sourceChoice = Read-Host "Choose an option (1 or 2)"

if ($sourceChoice -eq "1") {
    Write-Host "Fetching proxies from ProxyScrape API..." -NoNewline
    $apiUrl = "https://api.proxyscrape.com/v4/free-proxy-list/get?protocol=all&timeout=10000&country=all&ssl=all&anonymity=all&limit=2000"
    
    # Fire web request down onto temporary background space
    Invoke-WebRequest -Uri $apiUrl -OutFile $tempRawList -UseBasicParsing
    
    if (-not (Test-Path $tempRawList) -or (Get-Item $tempRawList).Length -eq 0) {
        Write-Error "Error: API download failed or returned zero size payload."
        return
    }
    Write-Host " Download complete!" -ForegroundColor Green
    $proxies = Get-Content $tempRawList
} 
elif ($sourceChoice -eq "2") {
    $inputFile = Read-Host "Enter the path to your input proxy file"
    if (-not (Test-Path $inputFile)) {
        Write-Error "Error: File '$inputFile' does not exist!"
        return
    }
    $proxies = Get-Content $inputFile
} 
else {
    Write-Error "Invalid selection. Ending script run."
    return
}

# 2. Setup target config mapping path
$confFile = Read-Host "Enter the path to the conf file [Default: /etc/proxychains4.conf]"
if ([string]::IsNullOrWhiteSpace($confFile)) {
    $confFile = "/etc/proxychains4.conf"
}

# 3. Handle data slicing logic quantities
[string]$countInput = Read-Host "How many proxies do you want to add"
if (-not [int]::TryParse($countInput, [ref]$proxyCount) -or $proxyCount -le 0) {
    Write-Error "Error: Please enter a valid number greater than 0."
    return
}

# 4. Out-of-bounds protection checks
if ($proxyCount -gt $proxies.Count) {
    Write-Host "Warning: You requested $proxyCount proxies, but only $($proxies.Count) exist. Using all available proxies." -ForegroundColor Yellow
    $proxyCount = $proxies.Count
}

# 5. Execute proxy regex reformatting engine
$formattedProxies = $proxies[0..($proxyCount - 1)] -replace '://', ' ' -replace ':', ' '

# Write the final appended columns
$formattedProxies | Out-File -FilePath $confFile -Append -Encoding ascii

# Housecleaning for downloaded transient elements
if (Test-Path $tempRawList) { Remove-Item $tempRawList }

# Setup graphic rendering space and echo output
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Write-Host ""
Write-Host "OK! WE ARE READY TO USE SOME PROXY-FU AND DISAPPEAR IN THE NOISE! 🥋🥷💨" -ForegroundColor Cyan
Write-Host "Success! Appended $proxyCount formatted proxies to: $confFile ✅" -ForegroundColor Green
