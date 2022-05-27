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

After setup, you can run the script again to manage users or uninstall OpenVPN.

[OpenVPN clients](https://openvpn.net/vpn-client/) are available for Windows, macOS, iOS, Android and Linux.

\* A cloud server, virtual private server (VPS) or dedicated server.

## Credits

This script is based on the great work of [Nyr and contributors](https://github.com/Nyr/openvpn-install), with enhancements and changes for compatibility with the [Setup IPsec VPN](https://github.com/hwdsl2/setup-ipsec-vpn) project.

## License

MIT
