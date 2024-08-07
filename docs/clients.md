[English](clients.md) | [中文](clients-zh.md)

# Configure OpenVPN Clients

[OpenVPN clients](https://openvpn.net/vpn-client/) are available for Windows, macOS, iOS, Android and Linux. macOS users can also use [Tunnelblick](https://tunnelblick.net).

To add a VPN connection, first securely transfer the generated `.ovpn` file to your device, then open the OpenVPN App and import the VPN profile.

To manage OpenVPN clients, run the install script again: `sudo bash openvpn.sh`.

Read [:book: VPN book](https://ko-fi.com/post/Support-this-project-and-get-access-to-supporter-o-O5O7FVF8J) to learn step-by-step instructions to configure and manage OpenVPN clients.

<details>
<summary>
View usage information for the OpenVPN script.
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
