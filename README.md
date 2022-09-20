[English](README.md) | [中文](README-zh.md)

# OpenVPN Server Auto Setup Script

OpenVPN server installer for Ubuntu, Debian, AlmaLinux, Rocky Linux, CentOS, Fedora and Amazon Linux 2.

This script will let you set up your own VPN server in just a few minutes, even if you haven't used OpenVPN before. [OpenVPN](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-4/) is an open-source, robust and highly flexible VPN protocol.

A video tutorial in Spanish is available: [Install OpenVPN/WireGuard on Ubuntu 20.04](https://www.youtube.com/watch?v=99qtaJU2E2k).

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

Alternative setup URLs:

```bash
https://github.com/hwdsl2/openvpn-install/raw/master/openvpn-install.sh
https://gitlab.com/hwdsl2/openvpn-install/-/raw/master/openvpn-install.sh
```

If you are unable to download, open [openvpn-install.sh](openvpn-install.sh), then click the `Raw` button on the right. Press `Ctrl/Cmd+A` to select all, `Ctrl/Cmd+C` to copy, then paste into your favorite editor.
</details>

\* A cloud server, virtual private server (VPS) or dedicated server.

## Next steps

After setup, you can run the script again to manage users or uninstall OpenVPN.

[OpenVPN clients](https://openvpn.net/vpn-client/) are available for Windows, macOS, iOS, Android and Linux. macOS users can also use [Tunnelblick](https://tunnelblick.net). To add a VPN connection, first securely transfer the generated `.ovpn` file to your device, then open the OpenVPN App and import the VPN profile.

Enjoy your very own VPN! :sparkles::tada::rocket::sparkles:

<details>
<summary>
Like this project? You can show your support or appreciation.
</summary>

<a href="https://ko-fi.com/hwdsl2" target="_blank"><img height="36" width="187" src="docs/images/kofi2.png" border="0" alt="Buy Me a Coffee at ko-fi.com" /></a> &nbsp;<a href="https://coindrop.to/hwdsl2" target="_blank"><img src="docs/images/embed-button.png" height="36" width="145" border="0" alt="Coindrop.to me" /></a>
</details>

## Credits

This script is based on the great work of [Nyr and contributors](https://github.com/Nyr/openvpn-install), with enhancements and changes for compatibility with the [Setup IPsec VPN](https://github.com/hwdsl2/setup-ipsec-vpn) project.

<details>
<summary>
List of enhancements over Nyr/openvpn-install.
</summary>

- Improved compatibility with Setup IPsec VPN
- Improved script reliability, user input and output
- Added support for Amazon Linux 2
- Supports exporting configuration for an existing VPN client
- Supports custom DNS server(s) for VPN clients
- Optimized `sysctl` settings for improved VPN performance
- Improved creation of client config files when using `sudo`

...and more!
</details>

## License

MIT
