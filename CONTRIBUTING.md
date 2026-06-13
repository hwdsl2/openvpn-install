# Contributing

Thanks for helping improve this project. This repository maintains the bare-metal OpenVPN install script; Docker image changes belong in [docker-openvpn](https://github.com/hwdsl2/docker-openvpn).

## Before You Start

- Search existing issues and pull requests.
- Keep changes focused and easy to review.
- For upstream OpenVPN or EasyRSA behavior, check the upstream project first.
- Do not include private keys, client certificates, `.ovpn` files, VPN credentials, or logs with secrets.

## Pull Requests

- Update `README.md` or docs when install behavior, options, service names, paths, or defaults change.
- Include the tested Linux distribution, version, architecture, hosting environment, protocol, and port.
- Note whether install, add/export/revoke client, or uninstall paths were tested.

## Testing

Test the smallest relevant path before opening a PR, for example:

- Run ShellCheck when editing shell scripts.
- Test install or client-management paths touched by the change.
- Check `systemctl status openvpn-server@server` or `openvpn@server` and relevant `journalctl` output.
- Verify client docs when changing generated `.ovpn` profiles.
