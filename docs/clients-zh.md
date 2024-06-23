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
  --auto                        auto install OpenVPN using default options
  --addclient [client name]     add a new client
  --exportclient [client name]  export configuration for an existing client
  --listclients                 list the names of existing clients
  --revokeclient [client name]  revoke an existing client
  --uninstall                   remove OpenVPN and delete all configuration
  -y, --yes                     assume "yes" as answer to prompts when revoking a client or removing OpenVPN
  -h, --help                    show this help message and exit

To customize install options, run this script without arguments.
```
</details>
