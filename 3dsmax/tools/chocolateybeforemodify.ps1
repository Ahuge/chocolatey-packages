#we are removing all packages named with a yearly release to prepare for the upgrade to next years version
$packageArgsSubstance  = @{
  packageName    = 'Substance In 3ds Max'
  fileType       = 'msi'
  silentArgs     = "{EAFD9CC5-E23B-44B8-8E45-4DC676B83542} /qn /norestart"
}
Uninstall-ChocolateyPackage @packageArgsSubstance

$packageArgs3dsMax  = @{
  packageName    = '3ds Max 2022'
  fileType       = 'msi'
  silentArgs     = "{5AA8C753-7FE4-40A6-A253-6DC5605544D9} /qn /norestart"
}
Uninstall-ChocolateyPackage @packageArgs3dsMax

$packageArgsPLB  = @{
  packageName    = 'Autodesk Advanced Material Library Base Resolution Image Library 2022'
  fileType       = 'msi'
  silentArgs     = "{7E78B513-B354-4833-8897-3ED5C515D30F} /qn /norestart"
}
Uninstall-ChocolateyPackage @packageArgsPLB

$packageArgsILB  = @{
  packageName    = 'Autodesk Material Library Base Resolution Image Library 2022'
  fileType       = 'msi'
  silentArgs     = "{6256584F-B04B-41D4-8A59-44E70940C473} /qn /norestart"
}
Uninstall-ChocolateyPackage @packageArgsILB

$packageArgsCM   = @{
  packageName    = 'Autodesk Material Library 2022'
  fileType       = 'msi'
  silentArgs     = "{A9221A68-5AD0-4215-B54F-CB5DBA4FB27C} /qn /norestart"
}
Uninstall-ChocolateyPackage @packageArgsCM