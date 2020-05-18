Write-Output "Starting script"

# $subscriptions = Get-AzSubscription

$context = Get-AzureRmContext 

Write-Output "-- Script is working on subscription : " $context.Subscription.SubscriptionId

$actions = @()
#foreach($sub in $subscriptions) {
    #$subscriptionName = $sub.Name
    #$sub | Set-AzContext

    $appInsightResources = Get-AzApplicationInsights

    Write-Output "Collecting AI Resources"
    $aiResources = @()
    foreach($ai in $appInsightResources) {
        $aiResources += Get-AzApplicationInsights -ResourceGroupName $ai.ResourceGroupName -Name $ai.Name -IncludeDailyCap
    }

    Write-Output "AI Resources collected, building table"
    foreach($ai in $aiResources) {              
        $actions += [PSCustomObject]@{
            #Subscription = $subscriptionName
            ResourceGroup = $ai.ResourceGroupName
            ResourceName = $ai.Name
            Cap = $ai.Cap
            MonthlyCost = (($ai.Cap * 31) - 5) * 2.3
            Action = $action
        }
    }

    Write-Output "Building table completed!"
#}

$actions | Sort-Object -Property MonthlyCost -Descending | Format-Table
