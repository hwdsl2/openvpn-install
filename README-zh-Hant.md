[English](README.md) | [简体中文](README-zh.md) | [繁體中文](README-zh-Hant.md) | [Video en Español](https://www.youtube.com/watch?v=99qtaJU2E2k)

# OpenVPN 伺服器一鍵安裝腳本

[![Build Status](https://github.com/hwdsl2/openvpn-install/actions/workflows/main.yml/badge.svg)](https://github.com/hwdsl2/openvpn-install/actions/workflows/main.yml) &nbsp;[![License: MIT](docs/images/license.svg)](https://opensource.org/licenses/MIT)

使用 Linux 腳本一鍵快速架設自己的 OpenVPN 伺服器。支援 Ubuntu、Debian、AlmaLinux、Rocky Linux、CentOS、Fedora、openSUSE、Amazon Linux 2 和 Raspberry Pi OS。

此腳本可讓你在幾分鐘內建立自己的 VPN 伺服器，即使你以前沒有使用過 OpenVPN。[OpenVPN](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-6/) 是一種開源、強大且高度靈活的 VPN 協定。

另見：[WireGuard](https://github.com/hwdsl2/wireguard-install/blob/master/README-zh-Hant.md) 和 [IPsec VPN](https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/README-zh-Hant.md) 伺服器一鍵安裝腳本。

**[&raquo; :book: Book: Privacy Tools in the Age of AI](docs/vpn-book-zh-Hant.md) &nbsp;[架設自己的 VPN 伺服器](docs/vpn-book-zh-Hant.md)**

## 功能特性

- 全自動的 OpenVPN 伺服器設定，無需使用者輸入
- 支援使用自訂選項進行互動式安裝
- 生成 VPN 設定檔以自動設定 Windows、macOS、iOS 和 Android 裝置
- 支援管理 OpenVPN 使用者與憑證
- 最佳化 `sysctl` 設定以提升 VPN 效能

## 安裝說明

首先在你的 Linux 伺服器\* 上下載腳本：

```bash
wget -O openvpn.sh https://get.vpnsetup.net/ovpn
```

\* 一個雲端伺服器、虛擬專用伺服器 (VPS) 或專用伺服器。

**選項 1：** 使用預設選項自動安裝 OpenVPN。

```bash
sudo bash openvpn.sh --auto
```

<details>
<summary>
查看腳本的範例輸出（終端記錄）。
</summary>

**註：** 此終端記錄僅用於示範用途。

<p align="center"><img src="docs/images/demo1.svg"></p>
</details>

對於有外部防火牆的伺服器（例如 [EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security-groups.html)/[GCE](https://cloud.google.com/firewall/docs/firewalls)），請為 VPN 開啟 UDP 連接埠 1194。

**選項 2：** 使用自訂選項進行互動式安裝。

```bash
sudo bash openvpn.sh
```

你可以自訂以下選項：VPN 伺服器的網域名稱、協定 (TCP/UDP) 和連接埠、VPN 客戶端的 DNS 伺服器以及第一個客戶端的名稱。

對於有外部防火牆的伺服器，請為 VPN 開啟所選的 TCP 或 UDP 連接埠。

<details>
<summary>
如果無法下載，請點這裡。
</summary>

你也可以使用 `curl` 下載：

```bash
curl -fL -o openvpn.sh https://get.vpnsetup.net/ovpn
```

然後依照上面的說明安裝。

或者，你也可以使用以下連結：

```bash
https://github.com/hwdsl2/openvpn-install/raw/master/openvpn-install.sh
https://gitlab.com/hwdsl2/openvpn-install/-/raw/master/openvpn-install.sh
```

如果無法下載，打開 [openvpn-install.sh](openvpn-install.sh)，然後點擊右側的 `Raw` 按鈕。按快捷鍵 `Ctrl/Cmd+A` 全選，`Ctrl/Cmd+C` 複製，然後貼上到你喜歡的編輯器。
</details>
<details>
<summary>
進階：使用自訂選項自動安裝。
</summary>

進階使用者可以使用自訂選項自動安裝 OpenVPN，方法是在執行腳本時指定命令列參數。有關更多資訊，請參見下一節，查看 OpenVPN 腳本的使用資訊。

或者，你也可以提供一個 Bash "here document" 作為安裝腳本的輸入。此方法也可用於在安裝後提供輸入以管理使用者。

首先，使用自訂選項以互動方式安裝 OpenVPN，並記下你對腳本的所有輸入值。

```bash
sudo bash openvpn.sh
```

如需移除 OpenVPN，請再次執行腳本並選擇適當的選項。

然後使用你的輸入值建立自訂安裝命令。例如：

```bash
sudo bash openvpn.sh <<ANSWERS
n
1
1194
2
client
y
ANSWERS
```

**註：** 安裝選項可能會在腳本的未來版本中發生變化。
</details>
<details>
<summary>
查看 OpenVPN 腳本的使用資訊。
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

## 下一步

安裝完成後，你可以再次執行腳本來管理使用者或移除 OpenVPN。

設定你的電腦或其他裝置使用 VPN。請參見：

**[設定 OpenVPN 客戶端](docs/clients-zh-Hant.md)**

**閱讀 [:book: VPN book](docs/vpn-book-zh-Hant.md) 以存取 [額外內容](https://ko-fi.com/post/Support-this-project-and-get-access-to-supporter-o-X8X5FVFZC)。**

開始使用自己的專屬 VPN! :sparkles::tada::rocket::sparkles:

## 致謝

此腳本基於 [Nyr 和 contributors](https://github.com/Nyr/openvpn-install) 的出色工作，並進行了增強與修改以與 [Setup IPsec VPN](https://github.com/hwdsl2/setup-ipsec-vpn) 專案相容。

<details>
<summary>
對 Nyr/openvpn-install 的改進列表。
</summary>

- 改進了與 Setup IPsec VPN 的相容性
- 改進了腳本的可靠性、使用者輸入與輸出
- 支援使用預設或自訂選項自動安裝
- 支援使用網域名稱作為伺服器位址
- 新增對 openSUSE Linux 的支援
- 新增對 Amazon Linux 2 的支援
- 支援匯出現有 VPN 客戶端的設定
- 支援列出現有的 VPN 客戶端
- 支援為 VPN 客戶端自訂 DNS 伺服器
- 支援使用命令列參數管理 VPN 客戶端
- 最佳化 `sysctl` 設定以提升 VPN 效能
- 在使用 `sudo` 時改進客戶端設定檔的建立

...以及更多！
</details>

## 授權條款

MIT
