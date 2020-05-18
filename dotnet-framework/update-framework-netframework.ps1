#Navigate to the proper directory first where the solution (.sln) is stored!
#Credits go to https://gist.github.com/Wabbbit/8326813cf723e0100b16b38f4c38fbe1, I kindly borrowed the code.

$versionToUse = "v4.8"  # <====== Change this version
Get-Content 'SolutionFileName.sln' |   # <====== Change this name
  Select-String 'Project\(' |
    ForEach-Object {
      $csprojLines = $_ -Split '[,=]' | ForEach-Object { $_.Trim('[ "{}]') };
      # pt1 is name, 2 is path, 3 is the guid      
      $content = Get-Content $csprojLines[2];
      $originalValue =[regex]::matches($content, "<TargetFrameworkVersion>(.*?)</TargetFrameworkVersion>").value
      Write-Host "PROJECT: $($csprojLines[1]) | $($originalValue)"
      $content -replace "<TargetFrameworkVersion>(.*?)</TargetFrameworkVersion>", "<TargetFrameworkVersion>$($versionToUse)</TargetFrameworkVersion>" | Set-Content $csprojLines[2]
    }