#!/bin/bash
#
# https://github.com/hwdsl2/openvpn-install
#
# Based on the work of Nyr and contributors at:
# https://github.com/Nyr/openvpn-install
#
# Copyright (c) 2022-2024 Lin Song <linsongui@gmail.com>
# Copyright (c) 2013-2023 Nyr
#
# Released under the MIT License, see the accompanying file LICENSE.txt
# or https://opensource.org/licenses/MIT

exiterr()  { echo "Error: $1" >&2; exit 1; }
exiterr2() { exiterr "'apt-get install' failed."; }
exiterr3() { exiterr "'yum install' failed."; }
exiterr4() { exiterr "'zypper install' failed."; }

check_ip() {
	IP_REGEX='^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'
	printf '%s' "$1" | tr -d '\n' | grep -Eq "$IP_REGEX"
}

check_dns_name() {
	FQDN_REGEX='^([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$'
	printf '%s' "$1" | tr -d '\n' | grep -Eq "$FQDN_REGEX"
}

check_root() {
	if [ "$(id -u)" != 0 ]; then
		exiterr "This installer must be run as root. Try 'sudo bash $0'"
	fi
}

check_shell() {
	# Detect Debian users running the script with "sh" instead of bash
	if readlink /proc/$$/exe | grep -q "dash"; then
		exiterr 'This installer needs to be run with "bash", not "sh".'
	fi
}

check_kernel() {
	# Detect OpenVZ 6
	if [[ $(uname -r | cut -d "." -f 1) -eq 2 ]]; then
		exiterr "The system is running an old kernel, which is incompatible with this installer."
	fi
}

check_os() {
	if grep -qs "ubuntu" /etc/os-release; then
		os="ubuntu"
		os_version=$(grep 'VERSION_ID' /etc/os-release | cut -d '"' -f 2 | tr -d '.')
		group_name="nogroup"
	elif [[ -e /etc/debian_version ]]; then
		os="debian"
		os_version=$(grep -oE '[0-9]+' /etc/debian_version | head -1)
		group_name="nogroup"
	elif [[ -e /etc/almalinux-release || -e /etc/rocky-release || -e /etc/centos-release ]]; then
		os="centos"
		os_version=$(grep -shoE '[0-9]+' /etc/almalinux-release /etc/rocky-release /etc/centos-release | head -1)
		group_name="nobody"
	elif grep -qs "Amazon Linux release 2 " /etc/system-release; then
		os="centos"
		os_version="7"
		group_name="nobody"
	elif grep -qs "Amazon Linux release 2023" /etc/system-release; then
		exiterr "Amazon Linux 2023 is not supported."
	elif [[ -e /etc/fedora-release ]]; then
		os="fedora"
		os_version=$(grep -oE '[0-9]+' /etc/fedora-release | head -1)
		group_name="nobody"
	elif [[ -e /etc/SUSE-brand && "$(head -1 /etc/SUSE-brand)" == "openSUSE" ]]; then
		os="openSUSE"
		os_version=$(tail -1 /etc/SUSE-brand | grep -oE '[0-9\\.]+')
		group_name="nogroup"
	else
		exiterr "This installer seems to be running on an unsupported distribution.
Supported distros are Ubuntu, Debian, AlmaLinux, Rocky Linux, CentOS, Fedora, openSUSE and Amazon Linux 2."
	fi
}

check_os_ver() {
	if [[ "$os" == "ubuntu" && "$os_version" -lt 2004 ]]; then
		exiterr "Ubuntu 20.04 or higher is required to use this installer.
This version of Ubuntu is too old and unsupported."
	fi
	if [[ "$os" == "debian" && "$os_version" -lt 10 ]]; then
		exiterr "Debian 10 or higher is required to use this installer.
This version of Debian is too old and unsupported."
	fi
	if [[ "$os" == "centos" && "$os_version" -lt 7 ]]; then
		exiterr "CentOS 7 or higher is required to use this installer.
This version of CentOS is too old and unsupported."
	fi
}

check_tun() {
	if [[ ! -e /dev/net/tun ]] || ! ( exec 7<>/dev/net/tun ) 2>/dev/null; then
		exiterr "The system does not have the TUN device available.
TUN needs to be enabled before running this installer."
	fi
}

set_client_name() {
	# Allow a limited set of characters to avoid conflicts
	client=$(sed 's/[^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_-]/_/g' <<< "$unsanitized_client")
}

parse_args() {
	while [ "$#" -gt 0 ]; do
		case $1 in
			--auto)
				auto=1
				shift
				;;
			--addclient)
				add_client=1
				unsanitized_client="$2"
				shift
				shift
				;;
			--exportclient)
				export_client=1
				unsanitized_client="$2"
				shift
				shift
				;;
			--listclients)
				list_clients=1
				shift
				;;
			--revokeclient)
				revoke_client=1
				unsanitized_client="$2"
				shift
				shift
				;;
			--uninstall)
				remove_ovpn=1
				shift
				;;
			-y|--yes)
				assume_yes=1
				shift
				;;
			-h|--help)
				show_usage
				;;
			*)
				show_usage "Unknown parameter: $1"
				;;
		esac
	done
}

check_args() {
	if [ "$auto" = 1 ] && [ -e "$OVPN_CONF" ]; then
		echo "Error: Invalid parameter '--auto'. OpenVPN is already set up on this server." >&2
		echo "       To manage OpenVPN clients, re-run this script without '--auto'." >&2
		exit 1
	fi
	if [ "$((add_client + export_client + list_clients + revoke_client))" -gt 1 ]; then
		show_usage "Invalid parameters. Specify only one of '--addclient', '--exportclient', '--listclients' or '--revokeclient'."
	fi
	if [ "$remove_ovpn" = 1 ]; then
		if [ "$((add_client + export_client + list_clients + revoke_client + auto))" -gt 0 ]; then
			show_usage "Invalid parameters. '--uninstall' cannot be specified with other parameters."
		fi
	fi
	if [ ! -e "$OVPN_CONF" ]; then
		[ "$add_client" = 1 ] && exiterr "You must first set up OpenVPN before adding a client."
		[ "$export_client" = 1 ] && exiterr "You must first set up OpenVPN before exporting a client."
		[ "$list_clients" = 1 ] && exiterr "You must first set up OpenVPN before listing clients."
		[ "$revoke_client" = 1 ] && exiterr "You must first set up OpenVPN before revoking a client."
		[ "$remove_ovpn" = 1 ] && exiterr "Cannot remove OpenVPN because it has not been set up on this server."
	fi
	if [ "$add_client" = 1 ]; then
		set_client_name
		if [ -z "$client" ]; then
			exiterr "Invalid client name. Use one word only, no special characters except '-' and '_'."
		elif [ -e /etc/openvpn/server/easy-rsa/pki/issued/"$client".crt ]; then
			exiterr "$client: invalid name. Client already exists."
		fi
	fi
	if [ "$export_client" = 1 ] || [ "$revoke_client" = 1 ]; then
		set_client_name
		if [ -z "$client" ] || [ ! -e /etc/openvpn/server/easy-rsa/pki/issued/"$client".crt ]; then
			exiterr "Invalid client name, or client does not exist."
		fi
	fi
}

check_nftables() {
	if [ "$os" = "centos" ]; then
		if grep -qs "hwdsl2 VPN script" /etc/sysconfig/nftables.conf \
			|| systemctl is-active --quiet nftables 2>/dev/null; then
			exiterr "This system has nftables enabled, which is not supported by this installer."
		fi
	fi
}

install_wget() {
	# Detect some Debian minimal setups where neither wget nor curl are installed
	if ! hash wget 2>/dev/null && ! hash curl 2>/dev/null; then
		if [ "$auto" = 0 ]; then
			echo "Wget is required to use this installer."
			read -n1 -r -p "Press any key to install Wget and continue..."
		fi
		export DEBIAN_FRONTEND=noninteractive
		(
			set -x
			apt-get -yqq update || apt-get -yqq update
			apt-get -yqq install wget >/dev/null
		) || exiterr2
	fi
}

install_iproute() {
	if ! hash ip 2>/dev/null; then
		if [ "$auto" = 0 ]; then
			echo "iproute is required to use this installer."
			read -n1 -r -p "Press any key to install iproute and continue..."
		fi
		if [ "$os" = "debian" ] || [ "$os" = "ubuntu" ]; then
			export DEBIAN_FRONTEND=noninteractive
			(
				set -x
				apt-get -yqq update || apt-get -yqq update
				apt-get -yqq install iproute2 >/dev/null
			) || exiterr2
		elif [ "$os" = "openSUSE" ]; then
			(
				set -x
				zypper install iproute2 >/dev/null
			) || exiterr4
		else
			(
				set -x
				yum -y -q install iproute >/dev/null
			) || exiterr3
		fi
	fi
}

show_header() {
cat <<'EOF'

OpenVPN Script
https://github.com/hwdsl2/openvpn-install
EOF
}

show_header2() {
cat <<'EOF'

Welcome to this OpenVPN server installer!
GitHub: https://github.com/hwdsl2/openvpn-install

EOF
}

show_header3() {
cat <<'EOF'

Copyright (c) 2022-2024 Lin Song
Copyright (c) 2013-2023 Nyr
EOF
}

show_usage() {
	if [ -n "$1" ]; then
		echo "Error: $1" >&2
	fi
	show_header
	show_header3
cat 1>&2 <<EOF

Usage: bash $0 [options]

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
EOF
	exit 1
}

show_welcome() {
	if [ "$auto" = 0 ]; then
		show_header2
		echo 'I need to ask you a few questions before starting setup.'
		echo 'You can use the default options and just press enter if you are OK with them.'
	else
		show_header
		echo
		echo 'Starting OpenVPN setup using default options.'
	fi
}

enter_server_address() {
	echo
	echo "Do you want OpenVPN clients to connect to this server using a DNS name,"
	printf "e.g. vpn.example.com, instead of its IP address? [y/N] "
	read -r response
	case $response in
		[yY][eE][sS]|[yY])
			use_dns_name=1
			echo
			;;
		*)
			use_dns_name=0
			;;
	esac
	if [ "$use_dns_name" = 1 ]; then
		read -rp "Enter the DNS name of this VPN server: " server_addr
		until check_dns_name "$server_addr"; do
			echo "Invalid DNS name. You must enter a fully qualified domain name (FQDN)."
			read -rp "Enter the DNS name of this VPN server: " server_addr
		done
		ip="$server_addr"
		echo
		echo "Note: Make sure this DNS name resolves to the IPv4 address"
		echo "      of this server. If you add or update the DNS record"
		echo "      at a later time, reboot this server to take effect."
	else
		detect_ip
		check_nat_ip
	fi
}

find_public_ip() {
	ip_url1="http://ipv4.icanhazip.com"
	ip_url2="http://ip1.dynupdate.no-ip.com"
	# Get public IP and sanitize with grep
	get_public_ip=$(grep -m 1 -oE '^[0-9]{1,3}(\.[0-9]{1,3}){3}$' <<< "$(wget -T 10 -t 1 -4qO- "$ip_url1" || curl -m 10 -4Ls "$ip_url1")")
	if ! check_ip "$get_public_ip"; then
		get_public_ip=$(grep -m 1 -oE '^[0-9]{1,3}(\.[0-9]{1,3}){3}$' <<< "$(wget -T 10 -t 1 -4qO- "$ip_url2" || curl -m 10 -4Ls "$ip_url2")")
	fi
}

detect_ip() {
	# If system has a single IPv4, it is selected automatically.
	if [[ $(ip -4 addr | grep inet | grep -vEc '127(\.[0-9]{1,3}){3}') -eq 1 ]]; then
		ip=$(ip -4 addr | grep inet | grep -vE '127(\.[0-9]{1,3}){3}' | cut -d '/' -f 1 | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}')
	else
		# Use the IP address on the default route
		ip=$(ip -4 route get 1 | sed 's/ uid .*//' | awk '{print $NF;exit}' 2>/dev/null)
		if ! check_ip "$ip"; then
			find_public_ip
			ip_match=0
			if [ -n "$get_public_ip" ]; then
				ip_list=$(ip -4 addr | grep inet | grep -vE '127(\.[0-9]{1,3}){3}' | cut -d '/' -f 1 | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}')
				while IFS= read -r line; do
					if [ "$line" = "$get_public_ip" ]; then
						ip_match=1
						ip="$line"
					fi
				done <<< "$ip_list"
			fi
			if [ "$ip_match" = 0 ]; then
				if [ "$auto" = 0 ]; then
					echo
					echo "Which IPv4 address should be used?"
					num_of_ip=$(ip -4 addr | grep inet | grep -vEc '127(\.[0-9]{1,3}){3}')
					ip -4 addr | grep inet | grep -vE '127(\.[0-9]{1,3}){3}' | cut -d '/' -f 1 | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}' | nl -s ') '
					read -rp "IPv4 address [1]: " ip_num
					until [[ -z "$ip_num" || "$ip_num" =~ ^[0-9]+$ && "$ip_num" -le "$num_of_ip" ]]; do
						echo "$ip_num: invalid selection."
						read -rp "IPv4 address [1]: " ip_num
					done
					[[ -z "$ip_num" ]] && ip_num=1
				else
					ip_num=1
				fi
				ip=$(ip -4 addr | grep inet | grep -vE '127(\.[0-9]{1,3}){3}' | cut -d '/' -f 1 | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}' | sed -n "$ip_num"p)
			fi
		fi
	fi
	if ! check_ip "$ip"; then
		echo "Error: Could not detect this server's IP address." >&2
		echo "Abort. No changes were made." >&2
		exit 1
	fi
}

check_nat_ip() {
	# If $ip is a private IP address, the server must be behind NAT
	if printf '%s' "$ip" | grep -qE '^(10|127|172\.(1[6-9]|2[0-9]|3[0-1])|192\.168|169\.254)\.'; then
		find_public_ip
		if ! check_ip "$get_public_ip"; then
			if [ "$auto" = 0 ]; then
				echo
				echo "This server is behind NAT. What is the public IPv4 address?"
				read -rp "Public IPv4 address: " public_ip
				until check_ip "$public_ip"; do
					echo "Invalid input."
					read -rp "Public IPv4 address: " public_ip
				done
			else
				echo "Error: Could not detect this server's public IP." >&2
				echo "Abort. No changes were made." >&2
				exit 1
			fi
		else
			public_ip="$get_public_ip"
		fi
	fi
}

show_config() {
	if [ "$auto" != 0 ]; then
		echo
		printf '%s' "Server IP: "
		[ -n "$public_ip" ] && printf '%s\n' "$public_ip" || printf '%s\n' "$ip"
		echo "Port: UDP/1194"
		echo "Client name: client"
		echo "Client DNS: Google Public DNS"
	fi
}

detect_ipv6() {
	ip6=""
	if [[ $(ip -6 addr | grep -c 'inet6 [23]') -ne 0 ]]; then
		ip6=$(ip -6 addr | grep 'inet6 [23]' | cut -d '/' -f 1 | grep -oE '([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}' | sed -n 1p)
	fi
}

select_protocol() {
	if [ "$auto" = 0 ]; then
		echo
		echo "Which protocol should OpenVPN use?"
		echo "   1) UDP (recommended)"
		echo "   2) TCP"
		read -rp "Protocol [1]: " protocol
		until [[ -z "$protocol" || "$protocol" =~ ^[12]$ ]]; do
			echo "$protocol: invalid selection."
			read -rp "Protocol [1]: " protocol
		done
		case "$protocol" in
			1|"")
			protocol=udp
			;;
			2)
			protocol=tcp
			;;
		esac
	else
		protocol=udp
	fi
}

select_port() {
	if [ "$auto" = 0 ]; then
		echo
		echo "Which port should OpenVPN listen to?"
		read -rp "Port [1194]: " port
		until [[ -z "$port" || "$port" =~ ^[0-9]+$ && "$port" -le 65535 ]]; do
			echo "$port: invalid port."
			read -rp "Port [1194]: " port
		done
		[[ -z "$port" ]] && port=1194
	else
		port=1194
	fi
}

enter_custom_dns() {
	read -rp "Enter primary DNS server: " dns1
	until check_ip "$dns1"; do
		echo "Invalid DNS server."
		read -rp "Enter primary DNS server: " dns1
	done
	read -rp "Enter secondary DNS server (Enter to skip): " dns2
	until [ -z "$dns2" ] || check_ip "$dns2"; do
		echo "Invalid DNS server."
		read -rp "Enter secondary DNS server (Enter to skip): " dns2
	done
}

select_dns() {
	if [ "$auto" = 0 ]; then
		echo
		echo "Select a DNS server for the clients:"
		echo "   1) Current system resolvers"
		echo "   2) Google Public DNS"
		echo "   3) Cloudflare DNS"
		echo "   4) OpenDNS"
		echo "   5) Quad9"
		echo "   6) AdGuard DNS"
		echo "   7) Custom"
		read -rp "DNS server [2]: " dns
		until [[ -z "$dns" || "$dns" =~ ^[1-7]$ ]]; do
			echo "$dns: invalid selection."
			read -rp "DNS server [2]: " dns
		done
	else
		dns=2
	fi
	if [ "$dns" = 7 ]; then
		enter_custom_dns
	fi
}

enter_first_client_name() {
	if [ "$auto" = 0 ]; then
		echo
		echo "Enter a name for the first client:"
		read -rp "Name [client]: " unsanitized_client
		set_client_name
		[[ -z "$client" ]] && client=client
	else
		client=client
	fi
}

show_setup_ready() {
	if [ "$auto" = 0 ]; then
		echo
		echo "OpenVPN installation is ready to begin."
	fi
}

check_firewall() {
	# Install a firewall if firewalld or iptables are not already available
	if ! systemctl is-active --quiet firewalld.service && ! hash iptables 2>/dev/null; then
		if [[ "$os" == "centos" || "$os" == "fedora" ]]; then
			firewall="firewalld"
		elif [[ "$os" == "openSUSE" ]]; then
			firewall="firewalld"
		elif [[ "$os" == "debian" || "$os" == "ubuntu" ]]; then
			firewall="iptables"
		fi
		if [[ "$firewall" == "firewalld" ]]; then
			# We don't want to silently enable firewalld, so we give a subtle warning
			# If the user continues, firewalld will be installed and enabled during setup
			echo
			echo "Note: firewalld, which is required to manage routing tables, will also be installed."
		fi
	fi
}

abort_and_exit() {
	echo "Abort. No changes were made." >&2
	exit 1
}

confirm_setup() {
	if [ "$auto" = 0 ]; then
		printf "Do you want to continue? [Y/n] "
		read -r response
		case $response in
			[yY][eE][sS]|[yY]|'')
				:
				;;
			*)
				abort_and_exit
				;;
		esac
	fi
}

show_start_setup() {
	echo
	echo "Installing OpenVPN, please wait..."
}

disable_limitnproc() {
	# If running inside a container, disable LimitNPROC to prevent conflicts
	if systemd-detect-virt -cq; then
		mkdir /etc/systemd/system/openvpn-server@server.service.d/ 2>/dev/null
		echo "[Service]
LimitNPROC=infinity" > /etc/systemd/system/openvpn-server@server.service.d/disable-limitnproc.conf
	fi
}

install_pkgs() {
	if [[ "$os" = "debian" || "$os" = "ubuntu" ]]; then
		export DEBIAN_FRONTEND=noninteractive
		(
			set -x
			apt-get -yqq update || apt-get -yqq update
			apt-get -yqq --no-install-recommends install openvpn >/dev/null
		) || exiterr2
		(
			set -x
			apt-get -yqq install openssl ca-certificates $firewall >/dev/null
		) || exiterr2
	elif [[ "$os" = "centos" ]]; then
		if grep -qs "Amazon Linux release 2 " /etc/system-release; then
			(
				set -x
				amazon-linux-extras install epel -y >/dev/null
			) || exit 1
		else
			(
				set -x
				yum -y -q install epel-release >/dev/null
			) || exiterr3
		fi
		(
			set -x
			yum -y -q install openvpn openssl ca-certificates tar $firewall >/dev/null 2>&1
		) || exiterr3
	elif [[ "$os" = "fedora" ]]; then
		(
			set -x
			dnf install -y openvpn openssl ca-certificates tar $firewall >/dev/null
		) || exiterr "'dnf install' failed."
	else
		# Else, OS must be openSUSE
		(
			set -x
			zypper install -y openvpn openssl ca-certificates tar $firewall >/dev/null
		) || exiterr4
	fi
	# If firewalld was just installed, enable it
	if [[ "$firewall" == "firewalld" ]]; then
		(
			set -x
			systemctl enable --now firewalld.service >/dev/null 2>&1
		)
	fi
}

remove_pkgs() {
	if [[ "$os" = "debian" || "$os" = "ubuntu" ]]; then
		(
			set -x
			rm -rf /etc/openvpn/server
			apt-get remove --purge -y openvpn >/dev/null
		)
	elif [[ "$os" = "openSUSE" ]]; then
		(
			set -x
			zypper remove -y openvpn >/dev/null
			rm -rf /etc/openvpn/server
		)
		rm -f /etc/openvpn/ipp.txt
	else
		# Else, OS must be CentOS or Fedora
		(
			set -x
			yum -y -q remove openvpn >/dev/null
			rm -rf /etc/openvpn/server
		)
	fi
}

create_firewall_rules() {
	if systemctl is-active --quiet firewalld.service; then
		# Using both permanent and not permanent rules to avoid a firewalld
		# reload.
		# We don't use --add-service=openvpn because that would only work with
		# the default port and protocol.
		firewall-cmd -q --add-port="$port"/"$protocol"
		firewall-cmd -q --zone=trusted --add-source=10.8.0.0/24
		firewall-cmd -q --permanent --add-port="$port"/"$protocol"
		firewall-cmd -q --permanent --zone=trusted --add-source=10.8.0.0/24
		# Set NAT for the VPN subnet
		firewall-cmd -q --direct --add-rule ipv4 nat POSTROUTING 0 -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j MASQUERADE
		firewall-cmd -q --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j MASQUERADE
		if [[ -n "$ip6" ]]; then
			firewall-cmd -q --zone=trusted --add-source=fddd:1194:1194:1194::/64
			firewall-cmd -q --permanent --zone=trusted --add-source=fddd:1194:1194:1194::/64
			firewall-cmd -q --direct --add-rule ipv6 nat POSTROUTING 0 -s fddd:1194:1194:1194::/64 ! -d fddd:1194:1194:1194::/64 -j MASQUERADE
			firewall-cmd -q --permanent --direct --add-rule ipv6 nat POSTROUTING 0 -s fddd:1194:1194:1194::/64 ! -d fddd:1194:1194:1194::/64 -j MASQUERADE
		fi
	else
		# Create a service to set up persistent iptables rules
		iptables_path=$(command -v iptables)
		ip6tables_path=$(command -v ip6tables)
		# nf_tables is not available as standard in OVZ kernels. So use iptables-legacy
		# if we are in OVZ, with a nf_tables backend and iptables-legacy is available.
		if [[ $(systemd-detect-virt) == "openvz" ]] && readlink -f "$(command -v iptables)" | grep -q "nft" && hash iptables-legacy 2>/dev/null; then
			iptables_path=$(command -v iptables-legacy)
			ip6tables_path=$(command -v ip6tables-legacy)
		fi
		echo "[Unit]
Before=network.target
[Service]
Type=oneshot
ExecStart=$iptables_path -t nat -A POSTROUTING -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j MASQUERADE
ExecStart=$iptables_path -I INPUT -p $protocol --dport $port -j ACCEPT
ExecStart=$iptables_path -I FORWARD -s 10.8.0.0/24 -j ACCEPT
ExecStart=$iptables_path -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
ExecStop=$iptables_path -t nat -D POSTROUTING -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j MASQUERADE
ExecStop=$iptables_path -D INPUT -p $protocol --dport $port -j ACCEPT
ExecStop=$iptables_path -D FORWARD -s 10.8.0.0/24 -j ACCEPT
ExecStop=$iptables_path -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT" > /etc/systemd/system/openvpn-iptables.service
		if [[ -n "$ip6" ]]; then
			echo "ExecStart=$ip6tables_path -t nat -A POSTROUTING -s fddd:1194:1194:1194::/64 ! -d fddd:1194:1194:1194::/64 -j MASQUERADE
ExecStart=$ip6tables_path -I FORWARD -s fddd:1194:1194:1194::/64 -j ACCEPT
ExecStart=$ip6tables_path -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
ExecStop=$ip6tables_path -t nat -D POSTROUTING -s fddd:1194:1194:1194::/64 ! -d fddd:1194:1194:1194::/64 -j MASQUERADE
ExecStop=$ip6tables_path -D FORWARD -s fddd:1194:1194:1194::/64 -j ACCEPT
ExecStop=$ip6tables_path -D FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT" >> /etc/systemd/system/openvpn-iptables.service
		fi
		echo "RemainAfterExit=yes
[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/openvpn-iptables.service
		(
			set -x
			systemctl enable --now openvpn-iptables.service >/dev/null 2>&1
		)
	fi
}

remove_firewall_rules() {
	port=$(grep '^port ' "$OVPN_CONF" | cut -d " " -f 2)
	protocol=$(grep '^proto ' "$OVPN_CONF" | cut -d " " -f 2)
	if systemctl is-active --quiet firewalld.service; then
		ip=$(firewall-cmd --direct --get-rules ipv4 nat POSTROUTING | grep '\-s 10.8.0.0/24 '"'"'!'"'"' -d 10.8.0.0/24' | grep -oE '[^ ]+$')
		# Using both permanent and not permanent rules to avoid a firewalld reload.
		firewall-cmd -q --remove-port="$port"/"$protocol"
		firewall-cmd -q --zone=trusted --remove-source=10.8.0.0/24
		firewall-cmd -q --permanent --remove-port="$port"/"$protocol"
		firewall-cmd -q --permanent --zone=trusted --remove-source=10.8.0.0/24
		firewall-cmd -q --direct --remove-rule ipv4 nat POSTROUTING 0 -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j MASQUERADE
		firewall-cmd -q --permanent --direct --remove-rule ipv4 nat POSTROUTING 0 -s 10.8.0.0/24 ! -d 10.8.0.0/24 -j MASQUERADE
		if grep -qs "server-ipv6" "$OVPN_CONF"; then
			ip6=$(firewall-cmd --direct --get-rules ipv6 nat POSTROUTING | grep '\-s fddd:1194:1194:1194::/64 '"'"'!'"'"' -d fddd:1194:1194:1194::/64' | grep -oE '[^ ]+$')
			firewall-cmd -q --zone=trusted --remove-source=fddd:1194:1194:1194::/64
			firewall-cmd -q --permanent --zone=trusted --remove-source=fddd:1194:1194:1194::/64
			firewall-cmd -q --direct --remove-rule ipv6 nat POSTROUTING 0 -s fddd:1194:1194:1194::/64 ! -d fddd:1194:1194:1194::/64 -j MASQUERADE
			firewall-cmd -q --permanent --direct --remove-rule ipv6 nat POSTROUTING 0 -s fddd:1194:1194:1194::/64 ! -d fddd:1194:1194:1194::/64 -j MASQUERADE
		fi
	else
		systemctl disable --now openvpn-iptables.service
		rm -f /etc/systemd/system/openvpn-iptables.service
	fi
	if sestatus 2>/dev/null | grep "Current mode" | grep -q "enforcing" && [[ "$port" != 1194 ]]; then
		semanage port -d -t openvpn_port_t -p "$protocol" "$port"
	fi
}

install_easyrsa() {
	# Get easy-rsa
	easy_rsa_url='https://github.com/OpenVPN/easy-rsa/releases/download/v3.2.0/EasyRSA-3.2.0.tgz'
	mkdir -p /etc/openvpn/server/easy-rsa/
	{ wget -t 3 -T 30 -qO- "$easy_rsa_url" 2>/dev/null || curl -m 30 -sL "$easy_rsa_url" ; } | tar xz -C /etc/openvpn/server/easy-rsa/ --strip-components 1
	if [ ! -f /etc/openvpn/server/easy-rsa/easyrsa ]; then
		exiterr "Failed to download EasyRSA from $easy_rsa_url."
	fi
	chown -R root:root /etc/openvpn/server/easy-rsa/
}

create_pki_and_certs() {
	cd /etc/openvpn/server/easy-rsa/ || exit 1
	(
		set -x
		# Create the PKI, set up the CA and the server and client certificates
		./easyrsa --batch init-pki >/dev/null
		./easyrsa --batch build-ca nopass >/dev/null 2>&1
		./easyrsa --batch --days=3650 build-server-full server nopass >/dev/null 2>&1
		./easyrsa --batch --days=3650 build-client-full "$client" nopass >/dev/null 2>&1
		./easyrsa --batch --days=3650 gen-crl >/dev/null 2>&1
	)
	# Move the stuff we need
	cp pki/ca.crt pki/private/ca.key pki/issued/server.crt pki/private/server.key pki/crl.pem /etc/openvpn/server
	# CRL is read with each client connection, while OpenVPN is dropped to nobody
	chown nobody:"$group_name" /etc/openvpn/server/crl.pem
	# Without +x in the directory, OpenVPN can't run a stat() on the CRL file
	chmod o+x /etc/openvpn/server/
	(
		set -x
		# Generate key for tls-crypt
		openvpn --genkey --secret /etc/openvpn/server/tc.key >/dev/null
	)
	# Create the DH parameters file using the predefined ffdhe2048 group
	echo '-----BEGIN DH PARAMETERS-----
MIIBCAKCAQEA//////////+t+FRYortKmq/cViAnPTzx2LnFg84tNpWp4TZBFGQz
+8yTnc4kmz75fS/jY2MMddj2gbICrsRhetPfHtXV/WVhJDP1H18GbtCFY2VVPe0a
87VXE15/V8k1mE8McODmi3fipona8+/och3xWKE2rec1MKzKT0g6eXq8CrGCsyT7
YdEIqUuyyOP7uWrat2DX9GgdT0Kj3jlN9K5W7edjcrsZCwenyO4KbXCeAvzhzffi
7MA0BM0oNC9hkXL+nOmFg/+OTxIy7vKBg8P+OxtMb61zO7X8vC7CIAXFjvGDfRaD
ssbzSibBsu/6iGtCOGEoXJf//////////wIBAg==
-----END DH PARAMETERS-----' > /etc/openvpn/server/dh.pem
}

create_dns_config() {
	case "$dns" in
		1)
			# Locate the proper resolv.conf
			# Needed for systems running systemd-resolved
			if grep '^nameserver' "/etc/resolv.conf" | grep -qv '127.0.0.53' ; then
				resolv_conf="/etc/resolv.conf"
			else
				resolv_conf="/run/systemd/resolve/resolv.conf"
			fi
			# Obtain the resolvers from resolv.conf and use them for OpenVPN
			grep -v '^#\|^;' "$resolv_conf" | grep '^nameserver' | grep -v '127.0.0.53' | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}' | while read line; do
				echo "push \"dhcp-option DNS $line\"" >> "$OVPN_CONF"
			done
		;;
		2|"")
			echo 'push "dhcp-option DNS 8.8.8.8"' >> "$OVPN_CONF"
			echo 'push "dhcp-option DNS 8.8.4.4"' >> "$OVPN_CONF"
		;;
		3)
			echo 'push "dhcp-option DNS 1.1.1.1"' >> "$OVPN_CONF"
			echo 'push "dhcp-option DNS 1.0.0.1"' >> "$OVPN_CONF"
		;;
		4)
			echo 'push "dhcp-option DNS 208.67.222.222"' >> "$OVPN_CONF"
			echo 'push "dhcp-option DNS 208.67.220.220"' >> "$OVPN_CONF"
		;;
		5)
			echo 'push "dhcp-option DNS 9.9.9.9"' >> "$OVPN_CONF"
			echo 'push "dhcp-option DNS 149.112.112.112"' >> "$OVPN_CONF"
		;;
		6)
			echo 'push "dhcp-option DNS 94.140.14.14"' >> "$OVPN_CONF"
			echo 'push "dhcp-option DNS 94.140.15.15"' >> "$OVPN_CONF"
		;;
		7)
			echo "push \"dhcp-option DNS $dns1\"" >> "$OVPN_CONF"
			if [ -n "$dns2" ]; then
				echo "push \"dhcp-option DNS $dns2\"" >> "$OVPN_CONF"
			fi
		;;
	esac
}

create_server_config() {
	# Generate server.conf
	echo "local $ip
port $port
proto $protocol
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
auth SHA256
tls-crypt tc.key
topology subnet
server 10.8.0.0 255.255.255.0" > "$OVPN_CONF"
	# IPv6
	if [[ -z "$ip6" ]]; then
		echo 'push "block-ipv6"' >> "$OVPN_CONF"
		echo 'push "ifconfig-ipv6 fddd:1194:1194:1194::2/64 fddd:1194:1194:1194::1"' >> "$OVPN_CONF"
	else
		echo 'server-ipv6 fddd:1194:1194:1194::/64' >> "$OVPN_CONF"
	fi
	echo 'push "redirect-gateway def1 ipv6 bypass-dhcp"' >> "$OVPN_CONF"
	echo 'ifconfig-pool-persist ipp.txt' >> "$OVPN_CONF"
	create_dns_config
	echo 'push "block-outside-dns"' >> "$OVPN_CONF"
	echo "keepalive 10 120
cipher AES-128-GCM
user nobody
group $group_name
persist-key
persist-tun
verb 3
crl-verify crl.pem" >> "$OVPN_CONF"
	if [[ "$protocol" = "udp" ]]; then
		echo "explicit-exit-notify" >> "$OVPN_CONF"
	fi
}

get_export_dir() {
	export_to_home_dir=0
	export_dir=~/
	if [ -n "$SUDO_USER" ] && getent group "$SUDO_USER" >/dev/null 2>&1; then
		user_home_dir=$(getent passwd "$SUDO_USER" 2>/dev/null | cut -d: -f6)
		if [ -d "$user_home_dir" ] && [ "$user_home_dir" != "/" ]; then
			export_dir="$user_home_dir/"
			export_to_home_dir=1
		fi
	fi
}

new_client() {
	get_export_dir
	# Generates the custom client.ovpn
	{
	cat /etc/openvpn/server/client-common.txt
	echo "<ca>"
	cat /etc/openvpn/server/easy-rsa/pki/ca.crt
	echo "</ca>"
	echo "<cert>"
	sed -ne '/BEGIN CERTIFICATE/,$ p' /etc/openvpn/server/easy-rsa/pki/issued/"$client".crt
	echo "</cert>"
	echo "<key>"
	cat /etc/openvpn/server/easy-rsa/pki/private/"$client".key
	echo "</key>"
	echo "<tls-crypt>"
	sed -ne '/BEGIN OpenVPN Static key/,$ p' /etc/openvpn/server/tc.key
	echo "</tls-crypt>"
	} > "$export_dir$client".ovpn
	if [ "$export_to_home_dir" = 1 ]; then
		chown "$SUDO_USER:$SUDO_USER" "$export_dir$client".ovpn
	fi
	chmod 600 "$export_dir$client".ovpn
}

update_sysctl() {
	mkdir -p /etc/sysctl.d
	conf_fwd="/etc/sysctl.d/99-openvpn-forward.conf"
	conf_opt="/etc/sysctl.d/99-openvpn-optimize.conf"
	# Enable net.ipv4.ip_forward for the system
	echo 'net.ipv4.ip_forward=1' > "$conf_fwd"
	if [[ -n "$ip6" ]]; then
		# Enable net.ipv6.conf.all.forwarding for the system
		echo "net.ipv6.conf.all.forwarding=1" >> "$conf_fwd"
	fi
	# Optimize sysctl settings such as TCP buffer sizes
	base_url="https://github.com/hwdsl2/vpn-extras/releases/download/v1.0.0"
	conf_url="$base_url/sysctl-ovpn-$os"
	[ "$auto" != 0 ] && conf_url="${conf_url}-auto"
	wget -t 3 -T 30 -q -O "$conf_opt" "$conf_url" 2>/dev/null \
		|| curl -m 30 -fsL "$conf_url" -o "$conf_opt" 2>/dev/null \
		|| { /bin/rm -f "$conf_opt"; touch "$conf_opt"; }
	# Enable TCP BBR congestion control if kernel version >= 4.20
	if modprobe -q tcp_bbr \
		&& printf '%s\n%s' "4.20" "$(uname -r)" | sort -C -V \
		&& [ -f /proc/sys/net/ipv4/tcp_congestion_control ]; then
cat >> "$conf_opt" <<'EOF'
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
EOF
	fi
	# Apply sysctl settings
	sysctl -e -q -p "$conf_fwd"
	sysctl -e -q -p "$conf_opt"
}

update_rclocal() {
	ipt_cmd="systemctl restart openvpn-iptables.service"
	if ! grep -qs "$ipt_cmd" /etc/rc.local; then
		if [ ! -f /etc/rc.local ]; then
			echo '#!/bin/sh' > /etc/rc.local
		else
			if [ "$os" = "ubuntu" ] || [ "$os" = "debian" ]; then
				sed --follow-symlinks -i '/^exit 0/d' /etc/rc.local
			fi
		fi
cat >> /etc/rc.local <<EOF

$ipt_cmd
EOF
		if [ "$os" = "ubuntu" ] || [ "$os" = "debian" ]; then
			echo "exit 0" >> /etc/rc.local
		fi
		chmod +x /etc/rc.local
	fi
}

update_selinux() {
	# If SELinux is enabled and a custom port was selected, we need this
	if sestatus 2>/dev/null | grep "Current mode" | grep -q "enforcing" && [[ "$port" != 1194 ]]; then
		# Install semanage if not already present
		if ! hash semanage 2>/dev/null; then
			if [[ "$os_version" -eq 7 ]]; then
				# Centos 7
				(
					set -x
					yum -y -q install policycoreutils-python >/dev/null
				) || exiterr3
			else
				# CentOS 8/9 or Fedora
				(
					set -x
					dnf install -y policycoreutils-python-utils >/dev/null
				) || exiterr "'dnf install' failed."
			fi
		fi
		semanage port -a -t openvpn_port_t -p "$protocol" "$port"
	fi
}

create_client_common() {
	# If the server is behind NAT, use the correct IP address
	[[ -n "$public_ip" ]] && ip="$public_ip"
	# client-common.txt is created so we have a template to add further users later
	echo "client
dev tun
proto $protocol
remote $ip $port
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
auth SHA256
cipher AES-128-GCM
ignore-unknown-option block-outside-dns block-ipv6
verb 3" > /etc/openvpn/server/client-common.txt
}

start_openvpn_service() {
	if [ "$os" != "openSUSE" ]; then
		(
			set -x
			systemctl enable --now openvpn-server@server.service >/dev/null 2>&1
		)
	else
		ln -s /etc/openvpn/server/* /etc/openvpn >/dev/null 2>&1
		(
			set -x
			systemctl enable --now openvpn@server.service >/dev/null 2>&1
		)
	fi
}

finish_setup() {
	echo
	echo "Finished!"
	echo
	echo "The client configuration is available in: $export_dir$client.ovpn"
	echo "New clients can be added by running this script again."
}

select_menu_option() {
	echo
	echo "OpenVPN is already installed."
	echo
	echo "Select an option:"
	echo "   1) Add a new client"
	echo "   2) Export config for an existing client"
	echo "   3) List existing clients"
	echo "   4) Revoke an existing client"
	echo "   5) Remove OpenVPN"
	echo "   6) Exit"
	read -rp "Option: " option
	until [[ "$option" =~ ^[1-6]$ ]]; do
		echo "$option: invalid selection."
		read -rp "Option: " option
	done
}

show_clients() {
	tail -n +2 /etc/openvpn/server/easy-rsa/pki/index.txt | grep "^V" | cut -d '=' -f 2 | nl -s ') '
}

enter_client_name() {
	echo
	echo "Provide a name for the client:"
	read -rp "Name: " unsanitized_client
	[ -z "$unsanitized_client" ] && abort_and_exit
	set_client_name
	while [[ -z "$client" || -e /etc/openvpn/server/easy-rsa/pki/issued/"$client".crt ]]; do
		if [ -z "$client" ]; then
			echo "Invalid client name. Use one word only, no special characters except '-' and '_'."
		else
			echo "$client: invalid name. Client already exists."
		fi
		read -rp "Name: " unsanitized_client
		[ -z "$unsanitized_client" ] && abort_and_exit
		set_client_name
	done
}

build_client_config() {
	cd /etc/openvpn/server/easy-rsa/ || exit 1
	(
		set -x
		./easyrsa --batch --days=3650 build-client-full "$client" nopass >/dev/null 2>&1
	)
}

print_client_action() {
	echo
	echo "$client $1. Configuration available in: $export_dir$client.ovpn"
}

print_check_clients() {
	echo
	echo "Checking for existing client(s)..."
}

check_clients() {
	num_of_clients=$(tail -n +2 /etc/openvpn/server/easy-rsa/pki/index.txt | grep -c "^V")
	if [[ "$num_of_clients" = 0 ]]; then
		echo
		echo "There are no existing clients!"
		exit 1
	fi
}

print_client_total() {
	if [ "$num_of_clients" = 1 ]; then
		printf '\n%s\n' "Total: 1 client"
	elif [ -n "$num_of_clients" ]; then
		printf '\n%s\n' "Total: $num_of_clients clients"
	fi
}

select_client_to() {
	echo
	echo "Select the client to $1:"
	show_clients
	read -rp "Client: " client_num
	[ -z "$client_num" ] && abort_and_exit
	until [[ "$client_num" =~ ^[0-9]+$ && "$client_num" -le "$num_of_clients" ]]; do
		echo "$client_num: invalid selection."
		read -rp "Client: " client_num
		[ -z "$client_num" ] && abort_and_exit
	done
	client=$(tail -n +2 /etc/openvpn/server/easy-rsa/pki/index.txt | grep "^V" | cut -d '=' -f 2 | sed -n "$client_num"p)
}

confirm_revoke_client() {
	if [ "$assume_yes" != 1 ]; then
		echo
		read -rp "Confirm $client revocation? [y/N]: " revoke
		until [[ "$revoke" =~ ^[yYnN]*$ ]]; do
			echo "$revoke: invalid selection."
			read -rp "Confirm $client revocation? [y/N]: " revoke
		done
	else
		revoke=y
	fi
}

print_revoke_client() {
	echo
	echo "Revoking $client..."
}

remove_client_conf() {
	get_export_dir
	ovpn_file="$export_dir$client.ovpn"
	if [ -f "$ovpn_file" ]; then
		echo "Removing $ovpn_file..."
		rm -f "$ovpn_file"
	fi
}

revoke_client_ovpn() {
	cd /etc/openvpn/server/easy-rsa/ || exit 1
	(
		set -x
		./easyrsa --batch revoke "$client" >/dev/null 2>&1
		./easyrsa --batch --days=3650 gen-crl >/dev/null 2>&1
	)
	rm -f /etc/openvpn/server/crl.pem
	cp /etc/openvpn/server/easy-rsa/pki/crl.pem /etc/openvpn/server/crl.pem
	# CRL is read with each client connection, when OpenVPN is dropped to nobody
	chown nobody:"$group_name" /etc/openvpn/server/crl.pem
	remove_client_conf
}

print_client_revoked() {
	echo
	echo "$client revoked!"
}

print_client_revocation_aborted() {
	echo
	echo "$client revocation aborted!"
}

confirm_remove_ovpn() {
	if [ "$assume_yes" != 1 ]; then
		echo
		read -rp "Confirm OpenVPN removal? [y/N]: " remove
		until [[ "$remove" =~ ^[yYnN]*$ ]]; do
			echo "$remove: invalid selection."
			read -rp "Confirm OpenVPN removal? [y/N]: " remove
		done
	else
		remove=y
	fi
}

print_remove_ovpn() {
	echo
	echo "Removing OpenVPN, please wait..."
}

disable_ovpn_service() {
	if [ "$os" != "openSUSE" ]; then
		systemctl disable --now openvpn-server@server.service
	else
		systemctl disable --now openvpn@server.service
	fi
	rm -f /etc/systemd/system/openvpn-server@server.service.d/disable-limitnproc.conf
}

remove_sysctl_rules() {
	rm -f /etc/sysctl.d/99-openvpn-forward.conf /etc/sysctl.d/99-openvpn-optimize.conf
	if [ ! -f /usr/bin/wg-quick ] && [ ! -f /usr/sbin/ipsec ] \
		&& [ ! -f /usr/local/sbin/ipsec ]; then
		echo 0 > /proc/sys/net/ipv4/ip_forward
		echo 0 > /proc/sys/net/ipv6/conf/all/forwarding
	fi
}

remove_rclocal_rules() {
	ipt_cmd="systemctl restart openvpn-iptables.service"
	if grep -qs "$ipt_cmd" /etc/rc.local; then
		sed --follow-symlinks -i "/^$ipt_cmd/d" /etc/rc.local
	fi
}

print_ovpn_removed() {
	echo
	echo "OpenVPN removed!"
}

print_ovpn_removal_aborted() {
	echo
	echo "OpenVPN removal aborted!"
}

ovpnsetup() {

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

check_root
check_shell
check_kernel
check_os
check_os_ver
check_tun

OVPN_CONF="/etc/openvpn/server/server.conf"

auto=0
assume_yes=0
add_client=0
export_client=0
list_clients=0
revoke_client=0
remove_ovpn=0

parse_args "$@"
check_args

if [ "$add_client" = 1 ]; then
	show_header
	echo
	build_client_config
	new_client
	print_client_action added
	exit 0
fi

if [ "$export_client" = 1 ]; then
	show_header
	new_client
	print_client_action exported
	exit 0
fi

if [ "$list_clients" = 1 ]; then
	show_header
	print_check_clients
	check_clients
	echo
	show_clients
	print_client_total
	exit 0
fi

if [ "$revoke_client" = 1 ]; then
	show_header
	confirm_revoke_client
	if [[ "$revoke" =~ ^[yY]$ ]]; then
		print_revoke_client
		revoke_client_ovpn
		print_client_revoked
		exit 0
	else
		print_client_revocation_aborted
		exit 1
	fi
fi

if [ "$remove_ovpn" = 1 ]; then
	show_header
	confirm_remove_ovpn
	if [[ "$remove" =~ ^[yY]$ ]]; then
		print_remove_ovpn
		remove_firewall_rules
		disable_ovpn_service
		remove_sysctl_rules
		remove_rclocal_rules
		remove_pkgs
		print_ovpn_removed
		exit 0
	else
		print_ovpn_removal_aborted
		exit 1
	fi
fi

if [[ ! -e "$OVPN_CONF" ]]; then
	check_nftables
	install_wget
	install_iproute
	show_welcome
	public_ip=""
	if [ "$auto" = 0 ]; then
		enter_server_address
	else
		detect_ip
		check_nat_ip
	fi
	show_config
	detect_ipv6
	select_protocol
	select_port
	select_dns
	enter_first_client_name
	show_setup_ready
	check_firewall
	confirm_setup
	show_start_setup
	disable_limitnproc
	install_pkgs
	install_easyrsa
	create_pki_and_certs
	create_server_config
	update_sysctl
	create_firewall_rules
	if [ "$os" != "openSUSE" ]; then
		update_rclocal
	fi
	update_selinux
	create_client_common
	start_openvpn_service
	new_client
	finish_setup
else
	show_header
	select_menu_option
	case "$option" in
		1)
			enter_client_name
			build_client_config
			new_client
			print_client_action added
			exit 0
		;;
		2)
			check_clients
			select_client_to export
			new_client
			print_client_action exported
			exit 0
		;;
		3)
			print_check_clients
			check_clients
			echo
			show_clients
			print_client_total
			exit 0
		;;
		4)
			check_clients
			select_client_to revoke
			confirm_revoke_client
			if [[ "$revoke" =~ ^[yY]$ ]]; then
				print_revoke_client
				revoke_client_ovpn
				print_client_revoked
				exit 0
			else
				print_client_revocation_aborted
				exit 1
			fi
		;;
		5)
			confirm_remove_ovpn
			if [[ "$remove" =~ ^[yY]$ ]]; then
				print_remove_ovpn
				remove_firewall_rules
				disable_ovpn_service
				remove_sysctl_rules
				remove_rclocal_rules
				remove_pkgs
				print_ovpn_removed
				exit 0
			else
				print_ovpn_removal_aborted
				exit 1
			fi
		;;
		6)
			exit 0
		;;
	esac
fi
}

## Defer setup until we have the complete script
ovpnsetup "$@"

exit 0
