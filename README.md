## openvpn-install

OpenVPN [road warrior](http://en.wikipedia.org/wiki/Road_warrior_%28computing%29) installer for Ubuntu, Debian, AlmaLinux, Rocky Linux, CentOS and Fedora.

This script will let you set up your own VPN server in just a few minutes, even if you haven't used [OpenVPN](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-4/) before. It has been designed to be as unobtrusive and universal as possible.

### Installation

Run the script on your Linux server\* and follow the prompts:

```bash
wget https://get.vpnsetup.net/ovpn -nv -O openvpn.sh
sudo bash openvpn.sh
```

You can run the script again after install to manage users or uninstall OpenVPN.

\* A cloud server, virtual private server (VPS) or dedicated server.

### Credits

This script is based on the great work of [Nyr and contributors](https://github.com/Nyr/openvpn-install), with changes to improve compatibility with the Setup IPsec VPN project. Please report any issues to the linked upstream repository.

### License

MIT
