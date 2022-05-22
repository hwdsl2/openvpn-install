[English](README.md) | [中文](README-zh.md)

## openvpn-install

OpenVPN server installer for Ubuntu, Debian, AlmaLinux, Rocky Linux, CentOS and Fedora.

This script will let you set up your own VPN server in just a few minutes, even if you haven't used [OpenVPN](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-4/) before.

### Installation

Run the script on your Linux server\* and follow the prompts:

```bash
wget https://get.vpnsetup.net/ovpn -O openvpn.sh
sudo bash openvpn.sh
```

After setup, you can run the script again to manage users or uninstall OpenVPN.

\* A cloud server, virtual private server (VPS) or dedicated server.

### Credits

This script is based on the great work of [Nyr and contributors](https://github.com/Nyr/openvpn-install), with enhancements and changes for compatibility with the Setup IPsec VPN project. Please report any issues to the linked upstream repository.

### License

MIT
