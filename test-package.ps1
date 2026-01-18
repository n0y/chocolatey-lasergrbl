if (choco list --lo -r -e lasergrbl) {
    Write-Host "'lasergrbl' package is installed"
    exit 0
}
Write-Host "'lasergrbl' package wasn't successfully installed"
exit 1