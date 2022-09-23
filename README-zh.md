[English](README.md) | [中文](README-zh.md)

# OpenVPN 服务器一键安装脚本

使用 Linux 脚本一键快速搭建自己的 OpenVPN 服务器。支持 Ubuntu, Debian, AlmaLinux, Rocky Linux, CentOS, Fedora 和 Amazon Linux 2。

该脚本可让你在几分钟内建立自己的 VPN 服务器，即使你以前没有使用过 OpenVPN。[OpenVPN](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-4/) 是一种开源、强大且高度灵活的 VPN 协议。

视频教程（西班牙语）：[在 Ubuntu 20.04 上安装 OpenVPN/WireGuard](https://www.youtube.com/watch?v=99qtaJU2E2k)。

[**&raquo; 另见：WireGuard VPN 服务器一键安装脚本**](https://github.com/hwdsl2/wireguard-install/blob/master/README-zh.md)

## 安装说明

在你的 Linux 服务器\* 上运行脚本，并按提示操作：

```bash
wget https://get.vpnsetup.net/ovpn -O openvpn.sh
sudo bash openvpn.sh
```

<details>
<summary>
或者，你也可以使用以下命令。
</summary>

你也可以使用 `curl` 下载：

```bash
curl -fL https://get.vpnsetup.net/ovpn -o openvpn.sh
sudo bash openvpn.sh
```

或者，你也可以使用这些链接：

```bash
https://github.com/hwdsl2/openvpn-install/raw/master/openvpn-install.sh
https://gitlab.com/hwdsl2/openvpn-install/-/raw/master/openvpn-install.sh
```

如果无法下载，打开 [openvpn-install.sh](openvpn-install.sh)，然后点击右边的 `Raw` 按钮。按快捷键 `Ctrl/Cmd+A` 全选，`Ctrl/Cmd+C` 复制，然后粘贴到你喜欢的编辑器。
</details>

\* 一个云服务器，虚拟专用服务器 (VPS) 或者专用服务器。

## 下一步

安装完成后，你可以再次运行脚本来管理用户或者卸载 OpenVPN。

[OpenVPN 客户端](https://openvpn.net/vpn-client/) 在 Windows, macOS, iOS, Android 和 Linux 上可用。macOS 用户也可以使用 [Tunnelblick](https://tunnelblick.net)。要添加 VPN 连接，首先将生成的 `.ovpn` 文件安全地传送到你的设备，然后打开 OpenVPN 应用程序并导入 VPN 配置文件。

开始使用自己的专属 VPN! :sparkles::tada::rocket::sparkles:

<details>
<summary>
如果你喜欢这个项目，可以表达你的支持或感谢。
</summary>

<a href="https://ko-fi.com/hwdsl2" target="_blank"><img height="36" width="187" src="docs/images/kofi2.png" border="0" alt="Buy Me a Coffee at ko-fi.com" /></a> &nbsp;&nbsp;<a href="https://coindrop.to/hwdsl2" target="_blank"><img src="docs/images/embed-button.png" height="36" width="145" border="0" alt="Coindrop.to me" /></a>

仅限支持者的内容可用。[点击查看详情](https://ko-fi.com/hwdsl2)。
</details>

## 致谢

此脚本基于 [Nyr 和 contributors](https://github.com/Nyr/openvpn-install) 的出色工作，并进行了增强和更改以与 [Setup IPsec VPN](https://github.com/hwdsl2/setup-ipsec-vpn) 项目兼容。

<details>
<summary>
对 Nyr/openvpn-install 的改进列表。
</summary>

- 改进了与 Setup IPsec VPN 的兼容性
- 改进了脚本的可靠性，用户输入和输出
- 增加了对 Amazon Linux 2 的支持
- 支持导出现有 VPN 客户端的配置
- 支持为 VPN 客户端自定义 DNS 服务器
- 优化 `sysctl` 设置以提高 VPN 性能
- 使用 `sudo` 时改进了客户端配置文件的创建

...和更多！
</details>

## 授权协议

MIT
