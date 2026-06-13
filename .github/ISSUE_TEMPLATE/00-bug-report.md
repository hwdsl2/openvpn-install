---
name: Bug report
about: Tell us about a problem you are experiencing
title: ''
labels: ''
assignees: ''

---

**Checklist**

- [ ] I read the [README](https://github.com/hwdsl2/openvpn-install/blob/master/README.md)
- [ ] I followed instructions to [configure VPN clients](https://github.com/hwdsl2/openvpn-install/blob/master/docs/clients.md)
- [ ] I searched existing [Issues](https://github.com/hwdsl2/openvpn-install/issues?q=is%3Aissue)
- [ ] This bug is about the VPN setup script, and not OpenVPN itself

<!---
Before posting logs or configuration, remove private keys, client certificates, VPN client profiles, passwords, server addresses you do not want public, and other secrets.
--->

**Describe the issue**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:

1. ...
2. ...

**Expected behavior**
A clear and concise description of what you expected to happen.

**Logs**
Add relevant error logs to help explain the problem, if applicable.

Useful commands include:

```bash
sudo systemctl status openvpn-server@server
sudo journalctl -u openvpn-server@server -n 50
```

On some systems, the service name is `openvpn@server`:

```bash
sudo systemctl status openvpn@server
sudo journalctl -u openvpn@server -n 50
```

If the issue may be related to firewall rules, also include:

```bash
sudo systemctl status openvpn-iptables
sudo journalctl -u openvpn-iptables -n 50
```

**Server (please complete the following information)**
- OS and version: [e.g. Debian 13]
- Architecture: [e.g. x86_64, arm64]
- Hosting provider (if applicable): [e.g. GCP, AWS]
- External firewall/NAT: [e.g. UDP 1194 open, custom TCP/UDP port open, not applicable]
- Script command used: [e.g. `sudo bash openvpn.sh --auto`, `sudo bash openvpn.sh --addclient client2`]
- Custom install options (if used): [e.g. `--listenaddr`, `--serveraddr`, `--proto`, `--port`, `--clientname`, `--dns1`, `--dns2`]

**Client (please complete the following information, if applicable)**
- Device: [e.g. iPhone 15]
- OS and version: [e.g. iOS 18]
- OpenVPN client app and version: [e.g. OpenVPN Connect 3.x, Tunnelblick 6.x]
- Setup method: [imported `.ovpn` file, manual configuration]

**Configuration**
If relevant, include redacted snippets from `/etc/openvpn/server/server.conf`. Do not include full `.ovpn` files, private keys, client certificates or passwords.

**Additional context**
Add any other context about the problem here.
