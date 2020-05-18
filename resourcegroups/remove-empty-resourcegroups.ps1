#$subscriptionId = "******"
 
# 1.Authentication
#Login-AzureRmAccount -SubscriptionId $subscriptionId
 
#1. Get current Azure Context
$context = Get-AzureRmContext
 
Write-Output "-- Clean script is working on subscription : " $context.Subscription.SubscriptionId
 
$emptyRgs = New-Object System.Collections.ArrayList
 
# 2. List all resource groups
$rgs = Get-AzureRmResourceGroup
 
# 3. Check empty resource groups
foreach($rg in $rgs)
{
   $resourcesCount = (Get-AzureRmResource | where {$_.ResourceGroupName –eq $rg.ResourceGroupName}).Count
 
   if ($resourcesCount -eq 0){
      Write-Output $rg.ResourceGroupName
      $emptyRgs.Add($rg.ResourceGroupName)
   }
}
 
#4. Ask for permission to delete resource groups
if ($emptyRgs.Count -eq 0){
   Write-Output "There is no resource group emty :)"
}
else
{
   $choice = [string]::Empty
 
   while ($choice -notmatch "[y|n]"){
      $choice = read-host "Do you want to delete empty resource groups ? (Y/N)"
   }
 
   if ($choice -eq "y"){
      foreach($emptyRg in $emptyRgs){
         Write-Output "deleting : " $emptyRg
         Remove-AzureRmResourceGroup -Name $emptyRg -Force
      }
   }
}
