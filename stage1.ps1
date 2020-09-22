#変数代入
$DirectoryName = "hoge.local"
#ユーザ名のみ　ドメインFQDN不要です。
$DomainJoinUser = "hoge"
$DomainJoinPassword = ConvertTo-SecureString -AsPlainText -Force "Passw0rd!"

#AD参加
$Credential = New-Object System.Management.Automation.PSCredential $DomainJoinUser, $DomainJoinPassword
Add-Computer -DomainName $DirectoryName -Credential $Credential -Force -Options JoinWithNewName,AccountCreate

#自動ログイン設定解除
Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUser
Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -PropertyType String -Value 0

#後片付け
Remove-Item C:\work -Recurse
Restart-Computer -Force