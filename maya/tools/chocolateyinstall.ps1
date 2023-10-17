$mayaPackageId    = "{42762096-E3FE-3521-9687-693E0B913A4F}"

$url1             = 'https://efulfillment.autodesk.com/NetSWDLD/2024/MAYA/42762096-E3FE-3521-9687-693E0B913A4F/SFX//Autodesk_Maya_2024_1_Update_Windows_64bit_dlm_001_002.sfx.exe'
$checksum1        = 'EDDBE50763EE58EBB03C43C8587800A8072E095B30CA97592A37ABEA938CADE4'
$url2             = 'https://efulfillment.autodesk.com/NetSWDLD/2024/MAYA/42762096-E3FE-3521-9687-693E0B913A4F/SFX//Autodesk_Maya_2024_1_Update_Windows_64bit_dlm_002_002.sfx.exe'
$checksum2        = 'A2E3C467D11B721D2F35E79AFFCEA6D584A7321F6425507893969C313FC95729'

$unzip            = Join-Path $env:TEMP 'Autodesk_Maya_2024_1_Update_Windows_64bit_dlm'

$downloadPath1  = Join-Path $env:TEMP 'Autodesk_Maya_2024_1_Update_Windows_64bit_dlm_001_002.sfx.exe'
$downloadPath2  = Join-Path $env:TEMP 'Autodesk_Maya_2024_1_Update_Windows_64bit_dlm_002_002.sfx.exe'
$packageDownloadArgsURL1 = @{
  packageName    = $env:ChocolateyPackageName
  url            = $url1
  fileFullPath   = $downloadPath1
  checksum       = $checksum1
  checksumType   = 'sha256'
}
$packageDownloadArgsURL2 = @{
  packageName    = $env:ChocolateyPackageName
  url            = $url2
  fileFullPath   = $downloadPath2
  checksum       = $checksum2
  checksumType   = 'sha256'
}

Get-ChocolateyWebFile @packageDownloadArgsURL1
Get-ChocolateyWebFile @packageDownloadArgsURL2

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  file          = $downloadPath1
  silentArgs    = "-suppresslaunch -d $env:TEMP"
  validExitCodes= @(0, 3010, 1641)
  softwareName  = 'autodeskmaya2024*'
}

Install-ChocolateyInstallPackage @packageArgs


#remove any reboot requests that may block the installation
$RegRebootRequired = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
if (Test-path $RegRebootRequired)
{
    Remove-Item -Path $RegRebootRequired
}

#setup.exe is apparently not silent so we have to install all parts individually below

$ags             = Join-Path $unzip 'x64\AGS\Autodesk Genuine Service.msi'
$packageArgsAGS  = @{
  packageName    = 'Autodesk Genuine Service'
  fileType       = 'msi'
  file           = $ags
  softwareName   = 'Autodesk Genuine Service*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641, 1603)
}
Install-ChocolateyInstallPackage @packageArgsAGS

$adsso           = Join-Path $unzip 'x64\AdSSO\AdSSO.msi'
$packageArgsAdSSO  = @{
  packageName    = 'Autodesk Single Sign On Component'
  fileType       = 'msi'
  file           = $adsso
  softwareName   = 'Autodesk Single Sign On Component*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @packageArgsAdSSO

$adsklic         = Join-Path $unzip 'x86\Licensing\AdskLicensing-installer.exe'
$packageArgsLic  = @{
  packageName    = 'Autodesk Licensing Installer'
  fileType       = 'exe'
  file           = $adsklic
  softwareName   = 'Autodesk Licensing Installer 1.0*'
  silentArgs     = '--mode unattended --unattendedmodeui none'
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @packageArgsLic

$vcRedist2022x64     = Join-Path $unzip '3rdParty\x64\VCRedist\2022\vcredist_x64.exe'
$vcRedistVersion     = "2022"
$packageArgsVcRedist2022x64  = @{
  packageName    = "vcredist ${vcRedistVersion} x64"
  fileType       = 'exe'
  file           = $vcRedist2022x64
  softwareName   = "Microsoft Visual C++ 2015-2022 Redistributable (x64)*"
  silentArgs     = '/q /norestart'
  validExitCodes = @(0, 1638, 3010, 5100)
}
Install-ChocolateyInstallPackage @packageArgsVcRedist2022x64

$vcRedist2022x86     = Join-Path $unzip '3rdParty\x86\VCRedist\2022\vcredist_x86.exe'
$vcRedistVersion     = "2022"
$packageArgsVcRedist2022x86  = @{
  packageName    = "vcredist ${vcRedistVersion} x86"
  fileType       = 'exe'
  file           = $vcRedist2022x86
  softwareName   = "Microsoft Visual C++ 2015-2022 Redistributable (x86)*"
  silentArgs     = '/q /norestart'
  validExitCodes = @(0, 1638, 3010, 5100)
}
Install-ChocolateyInstallPackage @packageArgsVcRedist2022x86

$adskapp         = Join-Path $unzip 'x86\ADSKAPP\AdApplicationManager-installer.exe'
$packageArgsADSKAPP = @{
  packageName    = 'Autodesk Desktop app'
  fileType       = 'exe'
  file           = $adskapp
  softwareName   = 'Autodesk Desktop app*'
  silentArgs     = '--mode unattended'
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @packageArgsADSKAPP

$maya            = Join-Path $unzip 'x64\Maya\Maya.msi'
$packageArgsMaya = @{
  packageName    = 'Autodesk Maya'
  fileType       = 'msi'
  file           = $maya
  softwareName   = 'Autodesk Maya 2024*'
  silentArgs     = 'ADSK_ODIS_SETUP="1" INSTALLDIR="C:\Program Files\Autodesk" /qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @packageArgsMaya

$mayaUsd     = Join-Path $unzip 'x64\MayaUSD\MayaUSD.msi'
$packageArgsMayaUSD  = @{
  packageName    = 'MayaUSD'
  fileType       = 'msi'
  file           = $mayaUsd
  softwareName   = 'MayaUSD 0.23.1*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @packageArgsMayaUSD

  $lookDevX     = Join-Path $unzip 'x64/LookdevX/LookdevX.msi'
$packageArgsMToA  = @{
  packageName    = "LookdevX"
  fileType       = 'msi'
  file           = $mToA
  softwareName   = "LookdevX 1.1.0*"
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 1638, 3010)
}
Install-ChocolateyInstallPackage @packageArgsMToA

$mToA     = Join-Path $unzip '3rdParty\MtoA\MtoA.exe'
$packageArgsMToA  = @{
  packageName    = "MtoA"
  fileType       = 'exe'
  file           = $mToA
  softwareName   = "Arnold renderer*"
  silentArgs     = '/S /FORCE_UNINSTALL=1 /norestart'
  validExitCodes = @(0, 1638, 3010)
}
Install-ChocolateyInstallPackage @packageArgsMToA

$bifrost     = Join-Path $unzip 'x64\Bifrost\bifrost.msi'
$packageArgsBifrost  = @{
  packageName    = 'Bifröst'
  fileType       = 'msi'
  file           = $bifrost
  softwareName   = 'Bifröst 2.7.0.1*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @packageArgsBifrost

$substance     = Join-Path $unzip 'x64\Substance\AdobeSubstance3DforMaya-2.3.2-2024-msvc14-x86_64.exe'
$packageArgsSubstance  = @{
  packageName    = "Substance"
  fileType       = 'exe'
  file           = $substance
  softwareName   = "Substance 2.3.2*"
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART'
  validExitCodes = @(0, 1638, 3010)
}
Install-ChocolateyInstallPackage @packageArgsSubstance

$RegRebootRequired = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
if (Test-path $RegRebootRequired)
{
    Remove-Item -Path $RegRebootRequired
}
