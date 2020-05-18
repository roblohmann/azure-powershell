$paths = Get-ChildItem -include *.csproj -Recurse

foreach($pathobject in $paths)
{
    $path = $pathobject.fullname
    $doc = New-Object System.Xml.XmlDocument
    $doc.Load($path)
    $child = $doc.CreateElement("CodeAnalysisRuleSet")
    $child.InnerText = "CodeAnalysis.ruleset"
    $node = $doc.SelectSingleNode("//Project/PropertyGroup")
	$CodeAnalysisRuleSetNode = $node.SelectSingleNode("CodeAnalysisRuleSet")
	
	if (-not $CodeAnalysisRuleSetNode) {
       write-host "CodeAnalysisRuleSet does not exist, appending..."
		
		$node.AppendChild($child)
		$doc.Save($path)
    }
    else {
	   write-host "CodeAnalysisRuleSet already exists!" 	   
    }    
}
