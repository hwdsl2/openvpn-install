[English](README.md) | [中文](README-zh.md) | [Vídeo en Español](https://www.youtube.com/watch?v=99qtaJU2E2k)

# OpenVPN Server Auto Setup Script

[![Build Status](https://github.com/hwdsl2/openvpn-install/actions/workflows/main.yml/badge.svg)](https://github.com/hwdsl2/openvpn-install/actions/workflows/main.yml) &nbsp;[![License: MIT](docs/images/license.svg)](https://opensource.org/licenses/MIT)

OpenVPN server installer for Ubuntu, Debian, AlmaLinux, Rocky Linux, CentOS, Fedora and Amazon Linux 2.

This script will let you set up your own VPN server in just a few minutes, even if you haven't used OpenVPN before. [OpenVPN](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-4/) is an open-source, robust and highly flexible VPN protocol.

[**&raquo; See also: WireGuard VPN Server Auto Setup Script**](https://github.com/hwdsl2/wireguard-install)

## Installation

Run the script on your Linux server\* and follow the prompts.

First, download the script:

```bash
wget -O openvpn.sh https://get.vpnsetup.net/ovpn
```

**Option 1:** Auto install OpenVPN using default options.

```bash
sudo bash openvpn.sh --auto
```

<details>
<summary>
List of default options.
</summary>

```
Protocol: UDP
Port: UDP/1194
Client name: client
Client DNS: Google Public DNS
```
</details>

For servers with an external firewall (e.g. [EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security-groups.html)/[GCE](https://cloud.google.com/vpc/docs/firewalls)), open UDP port 1194 for the VPN.

**Option 2:** Interactive install using custom options.

```bash
sudo bash openvpn.sh
```

<details>
<summary>
Click here if you are unable to download.
</summary>

You may also use `curl` to download:

```bash
curl -fL -o openvpn.sh https://get.vpnsetup.net/ovpn
```

Then follow the instructions above to install.

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

Get your computer or device to use the VPN. Please refer to:

**[Configure OpenVPN Clients](docs/clients.md)**

Enjoy your very own VPN! :sparkles::tada::rocket::sparkles:

<details>
<summary>
Like this project? You can show your support or appreciation.
</summary>

<a href="https://ko-fi.com/hwdsl2" target="_blank"><img height="36" width="187" src="docs/images/kofi2.png" border="0" alt="Buy Me a Coffee at ko-fi.com" /></a> &nbsp;&nbsp;<a href="https://coindrop.to/hwdsl2" target="_blank"><img src="docs/images/embed-button.png" height="36" width="145" border="0" alt="Coindrop.to me" /></a>

Supporter-only content is available. [Click to see details](https://ko-fi.com/hwdsl2).
</details>

## Credits

This script is based on the great work of [Nyr and contributors](https://github.com/Nyr/openvpn-install), with enhancements and changes for compatibility with the [Setup IPsec VPN](https://github.com/hwdsl2/setup-ipsec-vpn) project.

<details>
<summary>
List of enhancements over Nyr/openvpn-install.
</summary>

- Improved compatibility with Setup IPsec VPN
- Improved script reliability, user input and output
- Supports auto install using default options
- Added support for Amazon Linux 2
- Supports exporting configuration for an existing VPN client
- Supports listing existing VPN clients
- Supports custom DNS server(s) for VPN clients
- Optimized `sysctl` settings for improved VPN performance
- Improved creation of client config files when using `sudo`

...and more!
</details>

## License

MIT
