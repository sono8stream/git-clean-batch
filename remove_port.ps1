# 管理者で実行
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) { Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs; exit }

$ports=@(22,100,443);

# まずこれまでの設定を削除
for( $i = 0; $i -lt $ports.length; $i++ ){
  $port = $ports[$i];
  iex "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=*";
}

netsh interface portproxy show v4tov4

# 最後にファイアウォール設定
# ファイアウォール設定を一旦削除
iex "Remove-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' ";

Pause