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
  --auto                        auto install OpenVPN using default options
  --addclient [client name]     add a new client
  --exportclient [client name]  export configuration for an existing client
  --listclients                 list the names of existing clients
  --revokeclient [client name]  revoke an existing client
  --uninstall                   remove OpenVPN and delete all configuration
  -y, --yes                     assume "yes" as answer to prompts when revoking a client or removing OpenVPN
  -h, --help                    show this help message and exit

To customize install options, run this script without arguments.
```
</details>
