Push-Location $PSScriptRoot

Get-ChildItem -Recurse | Unblock-File

$copyParams = @{
    Path        = ".\c3da3050-4640-41ff-a89b-25defd9e7f4b"
    Destination = "c:\Windows\System32\update\run\c3da3050-4640-41ff-a89b-25defd9e7f4b\"
    Recurse     = $True
    Confirm     = $false
    Force       = $True
}

$copyParams2 = @{
    Path        = ".\UpdateScript"
    Destination = "c:\ProgramData\MOTION\script\UpdateScript\"
    Recurse     = $True
    Confirm     = $false
    Force       = $True
}

Copy-Item @copyParams
Copy-Item @copyParams2

function Set-UserPermission {
    Param($Path)
    #Update permissions on the new folder to prevent users from replacing script content.
    $User = "NT AUTHORITY\Authenticated Users"
    $ACL = Get-Acl -Path $Path
    $ACL.SetAccessRuleProtection($True, $True) # Remove inheritance 
    $ACL.Access | Where-Object {$_.IdentityReference -eq $User} | ForEach-Object {$ACL.RemoveAccessRule($_)}
    Set-ACL -Path $Path -AclObject $ACL | Out-Null # Apply ACL on folder
    $ACL = Get-Acl -Path $Path
    #Add ReadAndExecute back for Authenticated Users
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($User,"ReadAndExecute, Synchronize", "ContainerInherit,ObjectInherit", "None", "Allow")
    $ACL.SetAccessRule($AccessRule)
    Set-ACL -Path $Path -AclObject $ACL | Out-Null # Apply ACL on folder
    #####
}

Set-UserPermission "c:\Windows\System32\update\run\c3da3050-4640-41ff-a89b-25defd9e7f4b"
Set-UserPermission "c:\ProgramData\MOTION\script\UpdateScript"

Pop-Location
