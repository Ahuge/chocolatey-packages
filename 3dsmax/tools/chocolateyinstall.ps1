# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

# 1. See the _TODO.md that is generated top level and read through that
# 2. Follow the documentation below to learn how to create a package for the package type you are creating.
# 3. In Chocolatey scripts, ALWAYS use absolute paths - $toolsDir gets you to the package's tools directory.
$ErrorActionPreference = 'Stop'; # stop on all errors
# Internal packages (organizations) or software that has redistribution rights (community repo)
# - Use `Install-ChocolateyInstallPackage` instead of `Install-ChocolateyPackage`
#   and put the binaries directly into the tools folder (we call it embedding)
#$fileLocation = Join-Path $toolsDir 'NAME_OF_EMBEDDED_INSTALLER_FILE'
# If embedding binaries increase total nupkg size to over 1GB, use share location or download from urls
#$fileLocation = '\\SHARE_LOCATION\to\INSTALLER_FILE'
# Community Repo: Use official urls for non-redist binaries or redist where total package size is over 200MB
# Internal/Organization: Download from internal location (internet sources are unreliable)
$3dsmaxPackageId = "{B2EF7E27-4824-3656-A115-BFF401F11F7C}"
$url1             = 'https://efulfillment.autodesk.com/NetSWDLD/2022/3DSMAX/B2EF7E27-4824-3656-A115-BFF401F11F7C/SFX/Autodesk_3ds_Max_2022_EFGJKPS_Win_64bit_001_004.sfx.exe'
$checksum1        = '63F18E800F101CD32C47DC1AB67DDEC66539B910E21DFA07DED9B2EC8DE0E829'
$url2             = 'https://efulfillment.autodesk.com/NetSWDLD/2022/3DSMAX/B2EF7E27-4824-3656-A115-BFF401F11F7C/SFX/Autodesk_3ds_Max_2022_EFGJKPS_Win_64bit_002_004.sfx.exe'
$checksum2        = 'C018DBA27FC951E0FDD3101D21118D44DBD03FEDC5FD69370F525FE72BDD6F17'
$url3             = 'https://efulfillment.autodesk.com/NetSWDLD/2022/3DSMAX/B2EF7E27-4824-3656-A115-BFF401F11F7C/SFX/Autodesk_3ds_Max_2022_EFGJKPS_Win_64bit_003_004.sfx.exe'
$checksum3        = '6BEE19D5974CB1993035DDF067105CF9FF6D3624EB551EBE0BCE46A04DDD1F14'
$url4             = 'https://efulfillment.autodesk.com/NetSWDLD/2022/3DSMAX/B2EF7E27-4824-3656-A115-BFF401F11F7C/SFX/Autodesk_3ds_Max_2022_EFGJKPS_Win_64bit_004_004.sfx.exe'
$checksum4        = '0E3ABFD7BFDDF98CD7537113451C1B295A031CF866DE63E1A796B80A7BCA81E7'

$unzip            = Join-Path $env:TEMP 'Autodesk_3ds_Max_2022_EFGJKPS_Win_64bit'


$downloadPath1  = Join-Path $env:TEMP 'Autodesk_3ds_Max_2022_EFGJKPS_Win_64bit_001_004.sfx.exe'
$downloadPath2  = Join-Path $env:TEMP 'Autodesk_3ds_Max_2022_EFGJKPS_Win_64bit_002_004.sfx.exe'
$downloadPath3  = Join-Path $env:TEMP 'Autodesk_3ds_Max_2022_EFGJKPS_Win_64bit_003_004.sfx.exe'
$downloadPath4  = Join-Path $env:TEMP 'Autodesk_3ds_Max_2022_EFGJKPS_Win_64bit_004_004.sfx.exe'
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
$packageDownloadArgsURL3 = @{
  packageName    = $env:ChocolateyPackageName
  url            = $url3
  fileFullPath   = $downloadPath3
  checksum       = $checksum3
  checksumType   = 'sha256'
}
$packageDownloadArgsURL4 = @{
  packageName    = $env:ChocolateyPackageName
  url            = $url4
  fileFullPath   = $downloadPath4
  checksum       = $checksum4
  checksumType   = 'sha256'
}

Get-ChocolateyWebFile @packageDownloadArgsURL1
Get-ChocolateyWebFile @packageDownloadArgsURL2
Get-ChocolateyWebFile @packageDownloadArgsURL3
Get-ChocolateyWebFile @packageDownloadArgsURL4

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

$cm              = Join-Path $unzip 'Content\ADSKMaterials\CM\MaterialLibrary2022.msi'
$packageArgsCM   = @{
  packageName    = 'Autodesk Material Library 2022'
  fileType       = 'msi'
  file           = $cm
  softwareName   = 'Autodesk Material Library 2022*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @packageArgsCM

$ilb             = Join-Path $unzip 'Content\ADSKMaterials\ILB\BaseImageLibrary2022.msi'
$packageArgsILB  = @{
  packageName    = 'Autodesk Material Library Base Resolution Image Library 2022'
  fileType       = 'msi'
  file           = $ilb
  softwareName   = 'Autodesk Material Library Base Resolution Image Library 2022*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @packageArgsILB

$plb             = Join-Path $unzip 'Content\ADSKMaterials\PLB\PrismBaseImageLibrary2022.msi'
$packageArgsPLB  = @{
  packageName    = 'Autodesk Advanced Material Library Base Resolution Image Library 2022'
  fileType       = 'msi'
  file           = $plb
  softwareName   = 'Autodesk Advanced Material Library Base Resolution Image Library 2022*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @packageArgsPLB

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

$acadlt            = Join-Path $unzip 'x64\max\3dsMax.msi'
$packageArgs3DSMax = @{
  packageName    = '3ds Max 2022'
  fileType       = 'msi'
  file           = $acadlt
  softwareName   = '3ds Max 2022*'
  silentArgs     = 'ADSK_ODIS_SETUP="1" /qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @packageArgs3DSMax

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

$substance     = Join-Path $unzip 'x64\Substance\SubstanceIn3dsMax-2.4.3-2022-Windows.msi'
$packageArgsSubstance  = @{
  packageName    = 'Substance In 3ds Max'
  fileType       = 'msi'
  file           = $substance
  softwareName   = 'Substance In 3ds Max 2022 2.4.3*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @packageArgsSubstance

$vcRedist2010SP1     = Join-Path $unzip '3rdParty\x64\VCRedist\2010SP1\vcredist_x64.exe'
$vcRedistVersion     = "2010 SP1"
$packageArgsVcRedist2010SP1  = @{
  packageName    = "vcredist ${vcRedistVersion}"
  fileType       = 'exe'
  file           = $vcRedist2010SP1
  softwareName   = "Microsoft Visual C++ ${vcRedistVersion} Redistributable*"
  silentArgs     = '/quiet /norestart'
  validExitCodes = @(0, 1638, 3010)
}
Install-ChocolateyInstallPackage @packageArgsVcRedist2010SP1

$vcRedist2012UPD4     = Join-Path $unzip '3rdParty\x64\VCRedist\2012UPD4\vcredist_x64.exe'
$vcRedistVersion     = "2012 UPD4"
$packageArgsVcRedist2012UPD4  = @{
  packageName    = "vcredist ${vcRedistVersion}"
  fileType       = 'exe'
  file           = $vcRedist2012UPD4
  softwareName   = "Microsoft Visual C++ ${vcRedistVersion} Redistributable*"
  silentArgs     = '/quiet /norestart'
  validExitCodes = @(0, 1638, 3010)
}
Install-ChocolateyInstallPackage @packageArgsVcRedist2012UPD4

$vcRedist2013     = Join-Path $unzip '3rdParty\x64\VCRedist\2013\vcredist_x64.exe'
$vcRedistVersion     = "2013"
$packageArgsVcRedist2013  = @{
  packageName    = "vcredist ${vcRedistVersion}"
  fileType       = 'exe'
  file           = $vcRedist2013
  softwareName   = "Microsoft Visual C++ ${vcRedistVersion} Redistributable*"
  silentArgs     = '/quiet /norestart'
  validExitCodes = @(0, 1638, 3010)
}
Install-ChocolateyInstallPackage @packageArgsVcRedist2013

$vcRedist2015UPD3     = Join-Path $unzip '3rdParty\x64\VCRedist\2015UPD3\vcredist_x64.exe'
$vcRedistVersion     = "2015 UPD3"
$packageArgsVcRedist2015UPD3  = @{
  packageName    = "vcredist ${vcRedistVersion}"
  fileType       = 'exe'
  file           = $vcRedist2015UPD3
  softwareName   = "Microsoft Visual C++ ${vcRedistVersion} Redistributable*"
  silentArgs     = '/quiet /norestart'
  validExitCodes = @(0, 1638, 3010)
}
Install-ChocolateyInstallPackage @packageArgsVcRedist2015UPD3

$vcRedist2017     = Join-Path $unzip '3rdParty\x64\VCRedist\2017\vcredist_x64.exe'
$vcRedistVersion     = "2017"
$packageArgsVcRedist2017  = @{
  packageName    = "vcredist ${vcRedistVersion}"
  fileType       = 'exe'
  file           = $vcRedist2017
  softwareName   = "Microsoft Visual C++ ${vcRedistVersion} Redistributable*"
  silentArgs     = '/quiet /norestart'
  validExitCodes = @(0, 1638, 3010)
}
Install-ChocolateyInstallPackage @packageArgsVcRedist2017

$vcRedist2019     = Join-Path $unzip '3rdParty\x64\VCRedist\2019\vcredist_x64.exe'
$vcRedistVersion     = "2019"
$packageArgsVcRedist2019  = @{
  packageName    = "vcredist ${vcRedistVersion}"
  fileType       = 'exe'
  file           = $vcRedist2019
  softwareName   = "Microsoft Visual C++ ${vcRedistVersion} Redistributable*"
  silentArgs     = '/quiet /norestart'
  validExitCodes = @(0, 1638, 3010)
}
Install-ChocolateyInstallPackage @packageArgsVcRedist2019


## Main helper functions - these have error handling tucked into them already
## see https://chocolatey.org/docs/helpers-reference

## Install an application, will assert administrative rights
## - https://chocolatey.org/docs/helpers-install-chocolatey-package
## - https://chocolatey.org/docs/helpers-install-chocolatey-install-package
## add additional optional arguments as necessary
##Install-ChocolateyPackage $packageName $fileType $silentArgs $url [$url64 -validExitCodes $validExitCodes -checksum $checksum -checksumType $checksumType -checksum64 $checksum64 -checksumType64 $checksumType64]

## Download and unpack a zip file - https://chocolatey.org/docs/helpers-install-chocolatey-zip-package
##Install-ChocolateyZipPackage $packageName $url $toolsDir [$url64 -checksum $checksum -checksumType $checksumType -checksum64 $checksum64 -checksumType64 $checksumType64]

## Install Visual Studio Package - https://chocolatey.org/docs/helpers-install-chocolatey-vsix-package
#Install-ChocolateyVsixPackage $packageName $url [$vsVersion] [-checksum $checksum -checksumType $checksumType]
#Install-ChocolateyVsixPackage @packageArgs

## see the full list at https://chocolatey.org/docs/helpers-reference

## downloader that the main helpers use to download items
## if removing $url64, please remove from here
## - https://chocolatey.org/docs/helpers-get-chocolatey-web-file
#Get-ChocolateyWebFile $packageName 'DOWNLOAD_TO_FILE_FULL_PATH' $url $url64

## Installer, will assert administrative rights - used by Install-ChocolateyPackage
## use this for embedding installers in the package when not going to community feed or when you have distribution rights
## - https://chocolatey.org/docs/helpers-install-chocolatey-install-package
#Install-ChocolateyInstallPackage $packageName $fileType $silentArgs '_FULLFILEPATH_' -validExitCodes $validExitCodes

## Unzips a file to the specified location - auto overwrites existing content
## - https://chocolatey.org/docs/helpers-get-chocolatey-unzip
#Get-ChocolateyUnzip "FULL_LOCATION_TO_ZIP.zip" $toolsDir

## Runs processes asserting UAC, will assert administrative rights - used by Install-ChocolateyInstallPackage
## - https://chocolatey.org/docs/helpers-start-chocolatey-process-as-admin
#Start-ChocolateyProcessAsAdmin 'STATEMENTS_TO_RUN' 'Optional_Application_If_Not_PowerShell' -validExitCodes $validExitCodes

## To avoid quoting issues, you can also assemble your -Statements in another variable and pass it in
#$appPath = "$env:ProgramFiles\appname"
##Will resolve to C:\Program Files\appname
#$statementsToRun = "/C `"$appPath\bin\installservice.bat`""
#Start-ChocolateyProcessAsAdmin $statementsToRun cmd -validExitCodes $validExitCodes
    
## add specific folders to the path - any executables found in the chocolatey package 
## folder will already be on the path. This is used in addition to that or for cases 
## when a native installer doesn't add things to the path.
## - https://chocolatey.org/docs/helpers-install-chocolatey-path
#Install-ChocolateyPath 'LOCATION_TO_ADD_TO_PATH' 'User_OR_Machine' # Machine will assert administrative rights

## Add specific files as shortcuts to the desktop
## - https://chocolatey.org/docs/helpers-install-chocolatey-shortcut
#$target = Join-Path $toolsDir "$($packageName).exe"
# Install-ChocolateyShortcut -shortcutFilePath "<path>" -targetPath "<path>" [-workDirectory "C:\" -arguments "C:\test.txt" -iconLocation "C:\test.ico" -description "This is the description"]

## Outputs the bitness of the OS (either "32" or "64")
## - https://chocolatey.org/docs/helpers-get-o-s-architecture-width
#$osBitness = Get-ProcessorBits

## Set persistent Environment variables
## - https://chocolatey.org/docs/helpers-install-chocolatey-environment-variable
#Install-ChocolateyEnvironmentVariable -variableName "SOMEVAR" -variableValue "value" [-variableType = 'Machine' #Defaults to 'User']

## Set up a file association
## - https://chocolatey.org/docs/helpers-install-chocolatey-file-association
#Install-ChocolateyFileAssociation 

## Adding a shim when not automatically found - Cocolatey automatically shims exe files found in package directory.
## - https://chocolatey.org/docs/helpers-install-bin-file
## - https://chocolatey.org/docs/create-packages#how-do-i-exclude-executables-from-getting-shims
#Install-BinFile

##PORTABLE EXAMPLE
#$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# despite the name "Install-ChocolateyZipPackage" this also works with 7z archives
#Install-ChocolateyZipPackage $packageName $url $toolsDir $url64
## END PORTABLE EXAMPLE

## [DEPRECATING] PORTABLE EXAMPLE
#$binRoot = Get-BinRoot
#$installDir = Join-Path $binRoot "$packageName"
#Write-Host "Adding `'$installDir`' to the path and the current shell path"
#Install-ChocolateyPath "$installDir"
#$env:Path = "$($env:Path);$installDir"

# if removing $url64, please remove from here
# despite the name "Install-ChocolateyZipPackage" this also works with 7z archives
#Install-ChocolateyZipPackage "$packageName" "$url" "$installDir" "$url64"
## END PORTABLE EXAMPLE
