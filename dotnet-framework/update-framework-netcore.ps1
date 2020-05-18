#find all csproj files recursive in this directory
$paths = Get-ChildItem -include *.csproj -Recurse

$OnlyUpdateMatchingFrameworks = $true #can also be #false

$desiredTargetFramework = "netcoreapp3.1"

#foreach found file, update the framework
foreach($pathobject in $paths)
{
    $path = $pathobject.fullname
    $doc = New-Object System.Xml.XmlDocument
    $doc.Load($path)
    $node = $doc.SelectSingleNode("//Project/PropertyGroup")
	$TargetFrameworkNode = $node.SelectSingleNode("TargetFramework")
	
	if (-not $TargetFrameworkNode) {
       write-host "Node does not exist!"
    }
    else {
        write-host "Node found!"

        write-host "value was" + $TargetFrameworkNode.InnerText

        if($OnlyUpdateMatchingFrameworks -eq $true)
        {
            write-host "Only matching nodes may be updated! Checking.."

            if($TargetFrameworkNode.InnerText -like "netcoreapp*")
            {
                write-host "Updating node!"

                $TargetFrameworkNode.InnerText = $desiredTargetFramework    
            }
        }
        else{
            write-host "Updating node!"

            $TargetFrameworkNode.InnerText = $desiredTargetFramework
        }        

        write-host "value is" + $TargetFrameworkNode.InnerText

        $doc.Save($pathobject)
    }    
}