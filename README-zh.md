[English](README.md) | [中文](README-zh.md)

# OpenVPN 服务器一键安装脚本

使用 Linux 脚本一键快速搭建自己的 OpenVPN 服务器。支持 Ubuntu, Debian, AlmaLinux, Rocky Linux, CentOS 和 Fedora 系统。

该脚本可让你在几分钟内建立自己的 VPN 服务器，即使你以前没有使用过 OpenVPN。[OpenVPN](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-4/) 是一种开源、强大且高度灵活的 VPN 协议。

[**&raquo; 另见：WireGuard VPN 服务器一键安装脚本**](https://github.com/hwdsl2/wireguard-install/blob/master/README-zh.md)

## 安装说明

在你的 Linux 服务器\* 上运行脚本，并按提示操作：

```bash
wget https://get.vpnsetup.net/ovpn -O openvpn.sh
sudo bash openvpn.sh
```

<details>
<summary>
你也可以使用 curl 下载。
</summary>

```bash
curl -fL https://get.vpnsetup.net/ovpn -o openvpn.sh
sudo bash openvpn.sh
```

如果无法下载，打开 [openvpn-install.sh](openvpn-install.sh)，然后点击右边的 `Raw` 按钮。按快捷键 `Ctrl/Cmd+A` 全选，`Ctrl/Cmd+C` 复制，然后粘贴到你喜欢的编辑器。
</details>

\* 一个云服务器，虚拟专用服务器 (VPS) 或者专用服务器。

## 下一步

安装完成后，你可以再次运行脚本来管理用户或者卸载 OpenVPN。

[OpenVPN 客户端](https://openvpn.net/vpn-client/) 在 Windows, macOS, iOS, Android 和 Linux 上可用。要添加 VPN 连接，请将生成的 `.ovpn` 文件安全地传送到你的设备，然后打开 OpenVPN 应用程序并导入 VPN 配置文件。

开始使用自己的专属 VPN! :sparkles::tada::rocket::sparkles:

## 致谢

此脚本基于 [Nyr 和 contributors](https://github.com/Nyr/openvpn-install) 的出色工作，并进行了增强和更改以与 [Setup IPsec VPN](https://github.com/hwdsl2/setup-ipsec-vpn) 项目兼容。

## 授权协议

MIT
