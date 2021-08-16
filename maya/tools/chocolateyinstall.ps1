$mayaPackageId    = "{9CF605B0-2F2D-378F-9603-68A2199ECE65}"

$url1             = 'https://efulfillment.autodesk.com/NetSWDLD/2022/MAYA/9CF605B0-2F2D-378F-9603-68A2199ECE65/SFX/Autodesk_Maya_2022_1_ML_Windows_64bit_dlm_001_002.sfx.exe'
$checksum1        = '01C66556BB7B0EE60275284926FEFF0ED4D039761F29C848DF27A68B8AE9AAFD'
$url2             = 'https://efulfillment.autodesk.com/NetSWDLD/2022/MAYA/9CF605B0-2F2D-378F-9603-68A2199ECE65/SFX/Autodesk_Maya_2022_1_ML_Windows_64bit_dlm_002_002.sfx.exe'
$checksum2        = '17FD9C52999D7F46784972CE24912569AA57F556044B5A265E644AE39F77BEF1'

$unzip            = Join-Path $env:TEMP 'Autodesk_Maya_2022_1_ML_Windows_64bit_dlm'

$downloadPath1  = Join-Path $env:TEMP 'Autodesk_Maya_2022_1_ML_Windows_64bit_dlm_001_002.sfx.exe'
$downloadPath2  = Join-Path $env:TEMP 'Autodesk_Maya_2022_1_ML_Windows_64bit_dlm_002_002.sfx.exe'
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
  softwareName  = 'autodeskmaya2022*'
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

$vcRedist2019x64     = Join-Path $unzip '3rdParty\x64\VCRedist\2019\vcredist_x64.exe'
$vcRedistVersion     = "2019"
$packageArgsVcRedist2019x64  = @{
  packageName    = "vcredist ${vcRedistVersion} x64"
  fileType       = 'exe'
  file           = $vcRedist2019x64
  softwareName   = "Microsoft Visual C++ 2015-2019 Redistributable (x64)*"
  silentArgs     = '/q /norestart'
  validExitCodes = @(0, 1638, 3010, 5100)
}
Install-ChocolateyInstallPackage @packageArgsVcRedist2019x64

$vcRedist2019x86     = Join-Path $unzip '3rdParty\x86\VCRedist\2019\vcredist_x86.exe'
$vcRedistVersion     = "2019"
$packageArgsVcRedist2019x86  = @{
  packageName    = "vcredist ${vcRedistVersion} x86"
  fileType       = 'exe'
  file           = $vcRedist2019x86
  softwareName   = "Microsoft Visual C++ 2015-2019 Redistributable (x86)*"
  silentArgs     = '/q /norestart'
  validExitCodes = @(0, 1638, 3010, 5100)
}
Install-ChocolateyInstallPackage @packageArgsVcRedist2019x86

$maya            = Join-Path $unzip 'x64\Maya\Maya.msi'
$packageArgsMaya = @{
  packageName    = 'Autodesk Maya'
  fileType       = 'msi'
  file           = $maya
  softwareName   = 'Autodesk Maya 2022*'
  silentArgs     = 'ADSK_ODIS_SETUP="1" INSTALLDIR="C:\Program Files\Autodesk" /qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @packageArgsMaya

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
  softwareName   = 'Bifröst 2.2.1.2*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @packageArgsBifrost


$mayaUsd     = Join-Path $unzip 'x64\MayaUSD\MayaUSD.msi'
$packageArgsMayaUSD  = @{
  packageName    = 'MayaUSD'
  fileType       = 'msi'
  file           = $mayaUsd
  softwareName   = 'MayaUSD 0.10.0*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @packageArgsMayaUSD

$substance     = Join-Path $unzip 'x64\Substance\SubstanceInMaya-2.1.9-2022-Windows.exe'
$packageArgsSubstance  = @{
  packageName    = "Substance in Maya 2022"
  fileType       = 'exe'
  file           = $substance
  softwareName   = "Substance in Maya 2022*"
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART'
  validExitCodes = @(0, 1638, 3010)
}
Install-ChocolateyInstallPackage @packageArgsSubstance

$RegRebootRequired = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
if (Test-path $RegRebootRequired)
{
    Remove-Item -Path $RegRebootRequired
}
