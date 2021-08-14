#we are removing all packages named with a yearly release to prepare for the upgrade to next years version

$packageArgsMayaUSD  = @{
  packageName    = 'MayaUSD'
  fileType       = 'msi'
  silentArgs     = "{82A8F8B7-AC83-43B1-9567-48AC8D4E5E5C} /qn /norestart"
}
Uninstall-ChocolateyPackage @packageArgsMayaUSD

$packageArgsBifrost  = @{
  packageName    = 'Bifröst'
  fileType       = 'msi'
  silentArgs     = "{5094B2BC-3D25-4C04-9C20-50DDDFF110B7} /qn /norestart"
}
Uninstall-ChocolateyPackage @packageArgsBifrost
