$laserGrblInstallDir = Join-Path $env:ProgramData "LaserGRBL"

$packageArgs = @{
    PackageName    = 'lasergrbl'
    SoftwareName   = 'LaserGRBL*'
    ChecksumType   = 'sha256'
    Url64bit       = 'https://github.com/arkypita/LaserGRBL/releases/download/v%%VERSION%%/install.exe'
    Checksum64     = '%%CHECKSUM%%'
    ChecksumType64 = 'sha256'
    SilentArgs     = "/VERYSILENT /DIR=`"$laserGrblInstallDir`""
}

Install-ChocolateyPackage @packageArgs

"Fixing installer location"

[array]$key = Get-UninstallRegistryKey -SoftwareName "LaserGRBL*"
$registryParentPath = $key.PSParentPath
$registryChildName = $key.PSChildName
$lasergrblRegistryKey = "$registryParentPath\$registryChildName"

$lasergrblOriginalUninstallerString = $key.UninstallString.Trim('"')

if ($lasergrblOriginalUninstallerString.StartsWith($laserGrblInstallDir.Trim('"'))) {
    "Already installed to the correct location by upstream - no fix needed"
} else {
    $lasergrblOriginalUninstallerData = $lasergrblOriginalUninstallerString.Replace(".exe", ".dat")
    $lasergrblNewUninstallerString = Join-Path "$laserGrblInstallDir" "unins000.exe"
    $lasergrblNewUninstallerData = Join-Path "$laserGrblInstallDir" "unins000.dat"

    "Moving installer files"

    "  $lasergrblOriginalUninstallerString to $lasergrblNewUninstallerString"
    Move-Item -Path $lasergrblOriginalUninstallerString -Destination $lasergrblNewUninstallerString -Force

    "  $lasergrblOriginalUninstallerData  to $lasergrblNewUninstallerData"
    Move-Item -Path $lasergrblOriginalUninstallerData -Destination $laserGrblInstallDir -Force



    $registryUninstallerString = "`"$lasergrblNewUninstallerString`""
    $registryQuietUninstallerString = "`"$lasergrblNewUninstallerString`" /VERYSILENT"
    "Updating registry keys in $lasergrblRegistryKey"

    "  UninstallString     : $registryUninstallerString"
    Set-ItemProperty -Path $lasergrblRegistryKey -Name "UninstallString" -Value $registryUninstallerString

    "  QuietUninstallString: $registryQuietUninstallerString"
    Set-ItemProperty -Path $lasergrblRegistryKey -Name "QuietUninstallString" -Value $registryQuietUninstallerString
}