[English](README.md) | [中文](README-zh.md) | [Video en Español](https://www.youtube.com/watch?v=99qtaJU2E2k)

# OpenVPN 服务器一键安装脚本

[![Build Status](https://github.com/hwdsl2/openvpn-install/actions/workflows/main.yml/badge.svg)](https://github.com/hwdsl2/openvpn-install/actions/workflows/main.yml) &nbsp;[![License: MIT](docs/images/license.svg)](https://opensource.org/licenses/MIT)

使用 Linux 脚本一键快速搭建自己的 OpenVPN 服务器。支持 Ubuntu, Debian, AlmaLinux, Rocky Linux, CentOS, Fedora, openSUSE, Amazon Linux 2 和 Raspberry Pi OS。

该脚本可让你在几分钟内建立自己的 VPN 服务器，即使你以前没有使用过 OpenVPN。[OpenVPN](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-6/) 是一种开源、强大且高度灵活的 VPN 协议。

另见：[WireGuard](https://github.com/hwdsl2/wireguard-install/blob/master/README-zh.md) 和 [IPsec VPN](https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/README-zh.md) 服务器一键安装脚本。

---
#### [&raquo; :book: 限时免费电子书：Privacy Tools in the Age of AI](https://books2read.com/privacy?store=amazon)
---

## 功能特性

- 全自动的 OpenVPN 服务器配置，无需用户输入
- 支持使用自定义选项进行交互式安装
- 生成 VPN 配置文件以自动配置 Windows, macOS, iOS 和 Android 设备
- 支持管理 OpenVPN 用户和证书
- 优化 `sysctl` 设置以提高 VPN 性能

## 安装说明

首先在你的 Linux 服务器\* 上下载脚本：

```bash
wget -O openvpn.sh https://get.vpnsetup.net/ovpn
```

\* 一个云服务器，虚拟专用服务器 (VPS) 或者专用服务器。

**选项 1:** 使用默认选项自动安装 OpenVPN。

```bash
sudo bash openvpn.sh --auto
```

<details>
<summary>
查看脚本的示例输出（终端记录）。
</summary>

**注：** 此终端记录仅用于演示目的。

<p align="center"><img src="docs/images/demo1.svg"></p>
</details>

对于有外部防火墙的服务器（比如 [EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security-groups.html)/[GCE](https://cloud.google.com/firewall/docs/firewalls)），请为 VPN 打开 UDP 端口 1194。

**选项 2:** 使用自定义选项进行交互式安装。

```bash
sudo bash openvpn.sh
```

你可以自定义以下选项：VPN 服务器的域名，协议 (TCP/UDP) 和端口，VPN 客户端的 DNS 服务器以及第一个客户端的名称。

对于有外部防火墙的服务器，请为 VPN 打开所选的 TCP 或 UDP 端口。

<details>
<summary>
如果无法下载，请点这里。
</summary>

你也可以使用 `curl` 下载：

```bash
curl -fL -o openvpn.sh https://get.vpnsetup.net/ovpn
```

然后按照上面的说明安装。

或者，你也可以使用这些链接：

```bash
https://github.com/hwdsl2/openvpn-install/raw/master/openvpn-install.sh
https://gitlab.com/hwdsl2/openvpn-install/-/raw/master/openvpn-install.sh
```

如果无法下载，打开 [openvpn-install.sh](openvpn-install.sh)，然后点击右边的 `Raw` 按钮。按快捷键 `Ctrl/Cmd+A` 全选，`Ctrl/Cmd+C` 复制，然后粘贴到你喜欢的编辑器。
</details>
<details>
<summary>
高级：使用自定义选项自动安装。
</summary>

高级用户可以使用自定义选项自动安装 OpenVPN，方法是在运行脚本时指定命令行参数。有关更多信息，请参见下一节，查看 OpenVPN 脚本的使用信息。

或者，你也可以提供一个 Bash "here document" 作为安装脚本的输入。此方法还可用于在安装后提供输入以管理用户。

首先，使用自定义选项以交互方式安装 OpenVPN，并写下你对脚本的所有输入值。

```bash
sudo bash openvpn.sh
```

如需删除 OpenVPN，请再次运行脚本并选择适当的选项。

然后使用你的输入值创建自定义安装命令。例如：

```bash
sudo bash openvpn.sh <<ANSWERS
n
1
1194
2
client
y
ANSWERS
```

**注：** 安装选项可能会在脚本的未来版本中发生变化。
</details>
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

## 下一步

安装完成后，你可以再次运行脚本来管理用户或者卸载 OpenVPN。

配置你的计算机或其它设备使用 VPN。请参见：

**[配置 OpenVPN 客户端](docs/clients-zh.md)**

**阅读 [:book: VPN book](docs/vpn-book-zh.md) 以访问 [额外内容](https://ko-fi.com/post/Support-this-project-and-get-access-to-supporter-o-X8X5FVFZC)。**

开始使用自己的专属 VPN! :sparkles::tada::rocket::sparkles:

## 致谢

此脚本基于 [Nyr 和 contributors](https://github.com/Nyr/openvpn-install) 的出色工作，并进行了增强和更改以与 [Setup IPsec VPN](https://github.com/hwdsl2/setup-ipsec-vpn) 项目兼容。

<details>
<summary>
对 Nyr/openvpn-install 的改进列表。
</summary>

- 改进了与 Setup IPsec VPN 的兼容性
- 改进了脚本的可靠性，用户输入和输出
- 支持使用默认或自定义选项自动安装
- 支持使用域名作为服务器地址
- 增加了对 openSUSE Linux 的支持
- 增加了对 Amazon Linux 2 的支持
- 支持导出现有 VPN 客户端的配置
- 支持列出现有的 VPN 客户端
- 支持为 VPN 客户端自定义 DNS 服务器
- 支持使用命令行参数管理 VPN 客户端
- 优化 `sysctl` 设置以提高 VPN 性能
- 使用 `sudo` 时改进了客户端配置文件的创建

...和更多！
</details>

## 授权协议

MIT
