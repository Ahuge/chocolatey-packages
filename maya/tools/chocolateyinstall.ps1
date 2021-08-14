$mayaPackageId	  = "{9D725D29-4BE6-3ED9-A585-F4D5E20CECEE}"

$url1             = 'https://efulfillment.autodesk.com/NetSWDLD/2022/MAYA/9D725D29-4BE6-3ED9-A585-F4D5E20CECEE/SFX/Autodesk_Maya_2022_ML_Windows_64bit_dlm_001_002.sfx.exe'
$checksum1        = '2B435717311325C58CE4AD59716D66BEEA91EBC3DDB728CBB34B6ACF586A22C8'
$url2             = 'https://efulfillment.autodesk.com/NetSWDLD/2022/MAYA/9D725D29-4BE6-3ED9-A585-F4D5E20CECEE/SFX/Autodesk_Maya_2022_ML_Windows_64bit_dlm_002_002.sfx.exe'
$checksum2        = 'C0960DB926CB1B41C129110D2A1CC0D470F95190E4603B00D01F5652A02591E7'

$unzip            = Join-Path $env:TEMP 'Autodesk_Maya_2022_ML_Windows_64bit_dlm'

$downloadPath1  = Join-Path $env:TEMP 'Autodesk_Maya_2022_ML_Windows_64bit_dlm_001_002.sfx.exe'
$downloadPath2  = Join-Path $env:TEMP 'Autodesk_Maya_2022_ML_Windows_64bit_dlm_002_002.sfx.exe'
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
  softwareName   = 'Autodesk Licensing Installer*'
  silentArgs     = '--mode unattended'
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
  silentArgs     = '/quiet /norestart'
  validExitCodes = @(0, 1638, 3010)
}
Install-ChocolateyInstallPackage @packageArgsVcRedist2019x64

$vcRedist2019x86     = Join-Path $unzip '3rdParty\x86\VCRedist\2019\vcredist_x86.exe'
$vcRedistVersion     = "2019"
$packageArgsVcRedist2019x86  = @{
  packageName    = "vcredist ${vcRedistVersion} x86"
  fileType       = 'exe'
  file           = $vcRedist2019x86
  softwareName   = "Microsoft Visual C++ 2015-2019 Redistributable (x86)*"
  silentArgs     = '/quiet /norestart'
  validExitCodes = @(0, 1638, 3010)
}
Install-ChocolateyInstallPackage @packageArgsVcRedist2019x86

$maya            = Join-Path $unzip 'x64\Maya\Maya.msi'
$packageArgsMaya = @{
  packageName    = 'Autodesk Maya'
  fileType       = 'msi'
  file           = $maya
  softwareName   = 'Autodesk Maya 2022*'
  silentArgs     = 'ADSK_ODIS_SETUP="1" /qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @packageArgsMaya

$ags             = Join-Path $unzip 'x64\AGS\Autodesk Genuine Service.msi'
$packageArgsAGS  = @{
  packageName    = 'Autodesk Genuine Service'
  fileType       = 'msi'
  file           = $ags
  softwareName   = 'Autodesk Genuine Service*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @packageArgsAGS

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
$vcRedistVersion     = "2019"
$packageArgsMToA  = @{
  packageName    = "MtoA"
  fileType       = 'exe'
  file           = $mToA
  softwareName   = "Arnold renderer for Maya 2022*"
  silentArgs     = '/S /FORCE_UNINSTALL=1 /norestart'
  validExitCodes = @(0, 1638, 3010)
}
Install-ChocolateyInstallPackage @packageArgsMToA


$bifrost     = Join-Path $unzip 'x64\Bifrost\bifrost.msi'
$packageArgsBifrost  = @{
  packageName    = 'Bifröst'
  fileType       = 'msi'
  file           = $bifrost
  softwareName   = 'Bifröst 2.2.1.0 for Maya 2022*'
  silentArgs     = '/qn /norestart'	
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @packageArgsBifrost


$mayaUsd     = Join-Path $unzip 'x64\MayaUSD\MayaUSD.msi'
$packageArgsMayaUSD  = @{
  packageName    = 'MayaUSD'
  fileType       = 'msi'
  file           = $mayaUsd
  softwareName   = 'MayaUSD 0.8.0 for Maya 2022*'
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