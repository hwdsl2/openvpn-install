[English](clients.md) | [中文](clients-zh.md)

# 配置 OpenVPN 客户端

[OpenVPN 客户端](https://openvpn.net/vpn-client/) 在 Windows, macOS, iOS, Android 和 Linux 上可用。macOS 用户也可以使用 [Tunnelblick](https://tunnelblick.net)。

要添加 VPN 连接，首先将生成的 `.ovpn` 文件安全地传送到你的设备，然后打开 OpenVPN 应用程序并导入 VPN 配置文件。

要管理 OpenVPN 客户端，请再次运行安装脚本：`sudo bash openvpn.sh`。

阅读 [:book: VPN book](https://ko-fi.com/post/Support-this-project-and-get-access-to-supporter-o-X8X5FVFZC) 以了解配置和管理 OpenVPN 客户端的分步说明。

<details>
<summary>
查看 OpenVPN 脚本的使用信息。
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
