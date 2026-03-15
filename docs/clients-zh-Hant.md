[English](clients.md) | [简体中文](clients-zh.md) | [繁體中文](clients-zh-Hant.md) | [Русский](clients-ru.md)

# 設定 OpenVPN 客戶端

[OpenVPN 客戶端](https://openvpn.net/vpn-client/) 可在 Windows、macOS、iOS、Android 和 Linux 上使用。macOS 使用者也可以使用 [Tunnelblick](https://tunnelblick.net)。

要新增 VPN 連線，請先將生成的 `.ovpn` 檔案安全地傳送到你的裝置，然後開啟 OpenVPN 應用程式並匯入 VPN 設定檔。

要管理 OpenVPN 客戶端，請再次執行安裝腳本：`sudo bash openvpn.sh`。

閱讀 [:book: VPN book](vpn-book-zh-Hant.md) 以了解設定與管理 OpenVPN 客戶端的逐步說明。

<details>
<summary>
查看 OpenVPN 腳本的使用資訊。
</summary>

```
Usage: bash openvpn.sh [options]

Options:

  --addclient [client name]      add a new client
  --exportclient [client name]   export configuration for an existing client
  --listclients                  list the names of existing clients
  --revokeclient [client name]   revoke an existing client
  --uninstall                    remove OpenVPN and delete all configuration
  -y, --yes                      assume "yes" as answer to prompts when revoking a client or removing OpenVPN
  -h, --help                     show this help message and exit

Install options (optional):

  --auto                         auto install OpenVPN using default or custom options
  --listenaddr [IPv4 address]    IPv4 address that OpenVPN should listen on for requests
  --serveraddr [DNS name or IP]  server address, must be a fully qualified domain name (FQDN) or an IPv4 address
  --proto [TCP or UDP]           protocol for OpenVPN (TCP or UDP, default: UDP)
  --port [number]                port for OpenVPN (1-65535, default: 1194)
  --clientname [client name]     name for the first OpenVPN client (default: client)
  --dns1 [DNS server IP]         primary DNS server for clients (default: Google Public DNS)
  --dns2 [DNS server IP]         secondary DNS server for clients

To customize options, you may also run this script without arguments.
```
</details>
