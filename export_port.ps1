# 管理者で実行
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) { Start-Process powershell.exe "-File `"$PSCommandPath`"" -Verb RunAs; exit }

$ports=@(22,3000,443);

# まずこれまでの設定を削除
for( $i = 0; $i -lt $ports.length; $i++ ){
  $port = $ports[$i];
  iex "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=*";
}

# WSLのIPアドレスを取得しておく
$ip = wsl -e ip r |tail -n1|cut -d ' ' -f9

# 新たなポート設定を付与
$redirect_ports=@(22,80,443);
for( $i = 0; $i -lt $ports.length; $i++ ){
  $port = $ports[$i];
  $redirect_port = $redirect_ports[$i];
  iex "netsh interface portproxy add v4tov4 listenport=$port listenaddress=* connectport=$redirect_port connectaddress=$ip";
}

netsh interface portproxy show v4tov4

# 最後にファイアウォール設定
# ファイアウォール設定を一旦削除
iex "Remove-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' ";

# ファイアウォール設定を再適用
$ports_a = $ports -join ",";
iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort $ports_a -Action Allow -Protocol TCP";
iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Inbound -LocalPort $ports_a -Action Allow -Protocol TCP";

Pause