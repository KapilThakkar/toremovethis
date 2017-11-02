# Try write Immersion sentinel file to allow pending deployments to proceed
$temploc = "D:\Temp"
$sentinel_config = Get-Content (Join-Path $tempLoc 'blob_storage_config.json') | ConvertFrom-Json

# Find and import azure blob storage helper module
Get-ChildItem -Recurse -Path 'C:\Packages' -Include 'Immersion.psm1' | Select -First 1 | Import-Module

#Write-AzureBlobFile -StorageAccountName $sentinel_config.PrimaryStorageAccountName `
#                    -StorageAccountKey $sentinel_config.PrimaryStorageAccountKey `
#                    -BlobPath "assets/$($sentinel_config.ScriptSentinelFileName)" `
#                    -SourceBytes @( 0 )

write-output "Remove Autoadmin login and RunOnce"
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoAdminLogon -Value 0 -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0 -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name DefaultUserName -Value "" -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name DefaultPassword -Value "" -Force

#Force Log off of user
(gwmi win32_operatingsystem -ComputerName .).Win32Shutdown(4)
