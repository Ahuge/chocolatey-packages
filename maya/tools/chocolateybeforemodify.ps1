#we are removing all packages named with a yearly release to prepare for the upgrade to next years version
$packageArgsSubstance  = @{
  packageName    = 'Substance in Maya 2022'
  fileType       = 'exe'
  silentArgs     = "{6984DC4D-151A-4FCF-9932-6734395133DB} /qn /norestart"
}
Uninstall-ChocolateyPackage @packageArgsSubstance

$packageArgsMayaUSD  = @{
  packageName    = 'MayaUSD'
  fileType       = 'msi'
  silentArgs     = "{AA366680-F5F2-4565-BCB6-1712F17F9B06} /qn /norestart"
}
Uninstall-ChocolateyPackage @packageArgsMayaUSD

$packageArgsBifrost  = @{
  packageName    = 'Bifröst'
  fileType       = 'msi'
  silentArgs     = "{948B3BB3-7F2E-46FB-B737-AD0E16A947EA} /qn /norestart"
}
Uninstall-ChocolateyPackage @packageArgsBifrost

$packageArgsMtoA  = @{
  packageName    = 'MtoA'
  fileType       = 'exe'
  silentArgs     = "{9C8FFBE5-EEBD-4720-B5B6-E73D5AE4EA68} /S /FORCE_UNINSTALL=1"
}
Uninstall-ChocolateyPackage @packageArgsMtoA