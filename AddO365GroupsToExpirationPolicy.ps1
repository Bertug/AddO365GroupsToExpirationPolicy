<#The sample scripts are provided AS IS without warranty
of any kind. The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. In no
event, its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever
(including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary
loss) arising out of the use of or inability to use the sample scripts or documentation#>



$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

Connect-AzureAD


Get-UnifiedGroup | Set-UnifiedGroup -CustomAttribute1 "Expire"
Set-UnifiedGroup "GG" -CustomAttribute1 "DoNotExpire"

$ExpireGroups = Get-UnifiedGroup | Where{$_.customAttribute1 -eq "Expire"}



$PolicyId = (Get-AzureADMSGroupLifecyclePolicy).Id
Set-AzureADMSGroupLifecyclePolicy -ID $policyID -ManagedGroupTypes "Selected"




ForEach($group in $ExpireGroups){
    
    $CheckPolicy = (Get-UnifiedGroup -Identity $group.ExternalDirectoryObjectId).CustomAttribute2

    Write-Host "Adding group" $group.DisplayName "to group expiration policy"
    
    ## Remove-AzureADMSLifecyclePolicyGroup -GroupId $group.ExternalDirectoryObjectId -Id $PolicyId -ErrorAction SilentlyContinue
    Add-AzureADMSLifecyclePolicyGroup -GroupId $group.ExternalDirectoryObjectId -Id $PolicyId -ErrorAction SilentlyContinue
    
    Set-UnifiedGroup -Identity $group.externalDirectoryobjectID -CustomAttribute2 $PolicyId
    
    $Counter++ 
}

Write-Host "Completed." $Counter "Groups added to policy"