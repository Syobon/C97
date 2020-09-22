#アセンブリ読み込み
Add-Type -Assembly Microsoft.VisualBasic
Add-Type -Assembly System.Windows.Forms

#変数初期化
$input_hostname = $null

#変数代入
$kick_powershell = "powershell.exe Set-ExecutionPolicy Bypass -Scope process -Force;powershell.exe "
$script_path = "C:\work\scripts\stage1.ps1"
$exec_line = $kick_powershell + $script_path

#sysprep応答ファイルで追加したLocalAccounts
$username = "setupuser"
$password = "Passw0rd!"

#PC名入力
do {
    do {
        $input_hostname = [Microsoft.VisualBasic.Interaction]::InputBox("このコンピュータの名前を入力してください", "PC名の入力")
        #入力されたホスト名が空白かチェック
        $hostname_check = [String]::IsNullOrEmpty($input_hostname)
        if($hostname_check -eq "True") {
            [System.Windows.Forms.MessageBox]::Show("コンピュータ名が入力されていません。再度入力してください", "コンピュータ名が不正です", "OK", "Error","button1")
        }
    } while ($hostname_check -eq "True")
    #PC名確定確認
    $hostname_confirm = [System.Windows.Forms.MessageBox]::Show("コンピュータ名は" + $input_hostname + "でよいですか？", "コンピュータ名の確認", "YesNo", "Information","button1")
} while ($hostname_confirm -eq "No")

#ホスト名変更（Reboot pending）
Rename-Computer -NewName $input_hostname

#自動ログイン設定
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -PropertyType String -Value $username
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -PropertyType String -Value $password
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -PropertyType String -Value 1

#次回ログイン時にstage1.ps1実行
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce" -Name exec -PropertyType String -Value $exec_line

Restart-Computer -Force