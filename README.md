# AddO365GroupsToExpirationPolicy
Adding Office 365 Groups to an expiration policy via an attribute 

It is a sample script. So please do test it or use it to develop your own script. 

Problem statement: When you are trying to exclude some Office 365 Groups in your expiration policy and include rest of the Groups, 
you have to select O365 Groups one by one under selected tab in the expiration policy. Especially it becomes problamatic if the admin
has to select for example 1000 groups. It is hard to do one by one.

Therefore the script assigns all groups under the expiration policy except the ones that you would like to exclude.

Input: Exclusion list of O365 groups must be provided one by one.
Script: Will set all O365 Groups' customAttribute1 to "Expire". Exclusion list groups will be set to "$null" If you are using
CustomAttribute1 for another purpose, you can change it to a different one.
O365 groups including CustomAttribute1=Expire will be added to the expiration policy. 

The sample scripts are provided AS IS without warranty
of any kind. The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. In no
event, its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever
(including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation
