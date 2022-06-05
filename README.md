[English](README.md) | [中文](README-zh.md)

# OpenVPN Server Auto Setup Script

OpenVPN server installer for Ubuntu, Debian, AlmaLinux, Rocky Linux, CentOS and Fedora.

This script will let you set up your own VPN server in just a few minutes, even if you haven't used OpenVPN before. [OpenVPN](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-4/) is an open-source, robust and highly flexible VPN protocol.

[**&raquo; See also: WireGuard VPN Server Auto Setup Script**](https://github.com/hwdsl2/wireguard-install)

## Installation

Run the script on your Linux server\* and follow the prompts:

```bash
wget https://get.vpnsetup.net/ovpn -O openvpn.sh
sudo bash openvpn.sh
```

<details>
<summary>
Alternative commands.
</summary>

You may also use `curl` to download:

```bash
curl -fL https://get.vpnsetup.net/ovpn -o openvpn.sh
sudo bash openvpn.sh
```

Alternative setup URL:

```bash
https://github.com/hwdsl2/openvpn-install/raw/master/openvpn-install.sh
```

If you are unable to download, open [openvpn-install.sh](openvpn-install.sh), then click the `Raw` button on the right. Press `Ctrl/Cmd+A` to select all, `Ctrl/Cmd+C` to copy, then paste into your favorite editor.
</details>

\* A cloud server, virtual private server (VPS) or dedicated server.

## Next steps

After setup, you can run the script again to manage users or uninstall OpenVPN.

[OpenVPN clients](https://openvpn.net/vpn-client/) are available for Windows, macOS, iOS, Android and Linux. To add a VPN connection, first securely transfer the generated `.ovpn` file to your device, then open the OpenVPN App and import the VPN profile.

Enjoy your very own VPN! :sparkles::tada::rocket::sparkles:

## Credits

This script is based on the great work of [Nyr and contributors](https://github.com/Nyr/openvpn-install), with enhancements and changes for compatibility with the [Setup IPsec VPN](https://github.com/hwdsl2/setup-ipsec-vpn) project.

## License

MIT
