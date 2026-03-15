[English](clients.md) | [简体中文](clients-zh.md) | [繁體中文](clients-zh-Hant.md) | [Русский](clients-ru.md)

# Настройка клиентов OpenVPN

[Клиенты OpenVPN](https://openvpn.net/vpn-client/) доступны для Windows, macOS, iOS, Android и Linux. Пользователи macOS также могут использовать [Tunnelblick](https://tunnelblick.net).

Чтобы добавить VPN-подключение, сначала безопасно перенесите сгенерированный файл `.ovpn` на ваше устройство, затем откройте приложение OpenVPN и импортируйте VPN-профиль.

Чтобы управлять клиентами OpenVPN, снова запустите установочный скрипт: `sudo bash openvpn.sh`.

Прочитайте [:book: книгу о VPN](vpn-book.md), чтобы получить пошаговые инструкции по настройке и управлению клиентами OpenVPN.

<details>
<summary>
Просмотреть информацию об использовании скрипта OpenVPN.
</summary>

```
Usage: bash openvpn.sh [options]

Options:

  --addclient [client name]      добавить нового клиента
  --exportclient [client name]   экспортировать конфигурацию для существующего клиента
  --listclients                  вывести список существующих клиентов
  --revokeclient [client name]   отозвать существующего клиента
  --uninstall                    удалить OpenVPN и удалить всю конфигурацию
  -y, --yes                      автоматически отвечать "yes" на запросы при отзыве клиента или удалении OpenVPN
  -h, --help                     показать это сообщение справки и выйти

Параметры установки (необязательно):

  --auto                         автоматически установить OpenVPN с параметрами по умолчанию или пользовательскими параметрами
  --listenaddr [IPv4 address]    IPv4-адрес, на котором OpenVPN будет принимать запросы
  --serveraddr [DNS name or IP]  адрес сервера, должен быть полным доменным именем (FQDN) или IPv4-адресом
  --proto [TCP or UDP]           протокол для OpenVPN (TCP или UDP, по умолчанию: UDP)
  --port [number]                порт для OpenVPN (1–65535, по умолчанию: 1194)
  --clientname [client name]     имя первого клиента OpenVPN (по умолчанию: client)
  --dns1 [DNS server IP]         основной DNS-сервер для клиентов (по умолчанию: Google Public DNS)
  --dns2 [DNS server IP]         резервный DNS-сервер для клиентов

Чтобы настроить параметры, вы также можете запустить этот скрипт без аргументов.
```
</details>
