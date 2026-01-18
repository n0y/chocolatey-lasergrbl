$laserGrblInstallDir = Join-Path $env:ProgramData "LaserGRBL"

[array]$key = Get-UninstallRegistryKey -SoftwareName "LaserGRBL*"
$lasergrblOriginalUninstallerString = $key.UninstallString.Trim('"')

$packageArgs = @{
    PackageName = 'lasergrbl'
    File = $lasergrblOriginalUninstallerString
    FileType = 'EXE'
    SilentArgs = "/VERYSILENT"
}
Uninstall-ChocolateyPackage @packageArgs

"Removing any left-over files"
if ($laserGrblInstallDir.Length -lt 6 -or $laserGrblInstallDir -match "^[A-Z]:\\$") {
    "  No sane values for install path. Skipping"
} elseif (Test-Path $laserGrblInstallDir)  {
    "  files in $laserGrblInstallDir found. Removing it."
    Start-Sleep -Seconds 2
    Remove-Item -Path $laserGrblInstallDir -Recurse -Force -ErrorAction SilentlyContinue
}  else {
    "  no leftovers found."
}