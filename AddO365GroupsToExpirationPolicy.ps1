<#The sample scripts are provided AS IS without warranty
of any kind. The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. In no
event, its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever
(including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary
loss) arising out of the use of or inability to use the sample scripts or documentation#>


#Connect EXO
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

#Connect Azure AD
Connect-AzureAD

#Assigning all groups with the custom attruibute of Expire
Get-UnifiedGroup | Set-UnifiedGroup -CustomAttribute1 "Expire"

[string[]]$Exceptions = @()

#Requesting groups which are not going to be expired
#Changing the customattribute1 to null
do{
$input = Read-Host " What is the name of the group that you would like to exclude?"
$Exceptions += $input
}
until($input -eq "")

$Count = $Exceptions.count - 1

ForEach($i in $Count){
    Set-UnifiedGroup  -Identity $Exceptions[$i] -CustomAttribute1 $null
}


#storing all groups with customattribute1 to a variable
$ExpireGroups = Get-UnifiedGroup | Where{$_.customAttribute1 -eq "Expire"}

#getting expiration policyID
$PolicyId = (Get-AzureADMSGroupLifecyclePolicy).Id

#Expiration Policy to Selected so not All or None.
Set-AzureADMSGroupLifecyclePolicy -ID $policyID -ManagedGroupTypes "Selected"

#Adding groups to the policy
ForEach($group in $ExpireGroups){
    
    $CheckPolicy = (Get-UnifiedGroup -Identity $group.ExternalDirectoryObjectId).CustomAttribute2

    Write-Host "Adding group" $group.DisplayName "to group expiration policy"
    
    ##Remove-AzureADMSLifecyclePolicyGroup -GroupId $group.ExternalDirectoryObjectId -Id $PolicyId -ErrorAction SilentlyContinue
    Add-AzureADMSLifecyclePolicyGroup -GroupId $group.ExternalDirectoryObjectId -Id $PolicyId -ErrorAction SilentlyContinue
    
    
    ##Setting customattribute2 to the expiration policy ID so it will be easy to identify in the future
    Set-UnifiedGroup -Identity $group.externalDirectoryobjectID -CustomAttribute2 $PolicyId
    
    $Counter++ 
}

Write-Host "Completed." $Counter "Groups added to policy"