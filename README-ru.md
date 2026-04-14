[English](README.md) | [简体中文](README-zh.md) | [繁體中文](README-zh-Hant.md) | [Русский](README-ru.md) | [Video en Español](https://www.youtube.com/watch?v=99qtaJU2E2k)

# Скрипт автоматической установки сервера OpenVPN

[![Build Status](https://github.com/hwdsl2/openvpn-install/actions/workflows/main.yml/badge.svg)](https://github.com/hwdsl2/openvpn-install/actions/workflows/main.yml) [![GitHub Stars](https://img.shields.io/github/stars/hwdsl2/openvpn-install.svg?cacheSeconds=86400&logo=github&style=flat)](https://github.com/hwdsl2/openvpn-install/stargazers) [![License: MIT](docs/images/license.svg)](https://opensource.org/licenses/MIT)

Установщик сервера OpenVPN для Ubuntu, Debian, AlmaLinux, Rocky Linux, CentOS, Fedora, openSUSE, Amazon Linux 2 и Raspberry Pi OS.

Этот скрипт позволит вам настроить собственный VPN-сервер всего за несколько минут, даже если вы раньше не использовали OpenVPN. [OpenVPN](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-6/) — это протокол VPN с открытым исходным кодом, надёжный и очень гибкий.

**Также доступно:**
- Docker VPN: [WireGuard](https://github.com/hwdsl2/docker-wireguard/blob/main/README-ru.md), [OpenVPN](https://github.com/hwdsl2/docker-openvpn/blob/main/README-ru.md), [IPsec VPN](https://github.com/hwdsl2/docker-ipsec-vpn-server/blob/master/README-ru.md), [Headscale](https://github.com/hwdsl2/docker-headscale/blob/main/README-ru.md)
- Docker ИИ/Аудио: [Whisper (STT)](https://github.com/hwdsl2/docker-whisper/blob/main/README-ru.md), [Kokoro (TTS)](https://github.com/hwdsl2/docker-kokoro/blob/main/README-ru.md), [Embeddings](https://github.com/hwdsl2/docker-embeddings/blob/main/README-ru.md), [LiteLLM](https://github.com/hwdsl2/docker-litellm/blob/main/README-ru.md)
- :book: Книга: [Privacy Tools in the Age of AI](docs/vpn-book.md), [Build Your Own VPN Server](docs/vpn-book.md)

## Возможности

- Полностью автоматическая установка сервера OpenVPN, без ввода пользователя
- Поддержка интерактивной установки с пользовательскими параметрами
- Генерация VPN-профилей для автоматической настройки устройств Windows, macOS, iOS и Android
- Поддержка управления пользователями OpenVPN и сертификатами
- Оптимизация настроек `sysctl` для повышения производительности VPN

## Установка

Сначала загрузите скрипт на ваш Linux-сервер\*:

```
wget -O openvpn.sh https://get.vpnsetup.net/ovpn
```

\* Облачный сервер, виртуальный частный сервер (VPS) или выделенный сервер.

**Вариант 1:** Автоматическая установка OpenVPN с параметрами по умолчанию.

```
sudo bash openvpn.sh --auto
```

<details>
<summary>
Посмотреть работу скрипта (запись терминала).
</summary>

**Примечание:** Эта запись предназначена только для демонстрационных целей.

<p align="center"><img src="docs/images/demo1.svg"></p>
</details>

**Примечание:** При желании вы можете установить [WireGuard](https://github.com/hwdsl2/wireguard-install/blob/master/README-ru.md), [IPsec VPN](https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/README-ru.md) и/или [Headscale](https://github.com/hwdsl2/headscale-install/blob/main/README-ru.md) на тот же сервер.

Для серверов с внешним файрволом (например, [EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security-groups.html)/[GCE](https://cloud.google.com/firewall/docs/firewalls)) откройте UDP-порт 1194 для VPN.

**Вариант 2:** Интерактивная установка с пользовательскими параметрами.

```
sudo bash openvpn.sh
```

Вы можете настроить следующие параметры: DNS-имя VPN-сервера, протокол (TCP/UDP) и порт, DNS-сервер для VPN-клиентов и имя первого клиента.

Для серверов с внешним файрволом откройте выбранный TCP или UDP-порт для VPN.

<details>
<summary>
Нажмите здесь, если не удаётся скачать.
</summary>

Вы также можете использовать `curl` для загрузки:

```
curl -fL -o openvpn.sh https://get.vpnsetup.net/ovpn
```

Затем следуйте инструкциям выше для установки.

Альтернативные URL для установки:

```
https://github.com/hwdsl2/openvpn-install/raw/master/openvpn-install.sh
https://gitlab.com/hwdsl2/openvpn-install/-/raw/master/openvpn-install.sh
```

Если вы не можете скачать файл, откройте [openvpn-install.sh](openvpn-install.sh), затем нажмите кнопку `Raw` справа. Нажмите `Ctrl/Cmd+A`, чтобы выделить всё, `Ctrl/Cmd+C`, чтобы скопировать, затем вставьте в ваш любимый редактор.
</details>
<details>
<summary>
Дополнительно: автоматическая установка с пользовательскими параметрами.
</summary>

Продвинутые пользователи могут автоматически установить OpenVPN с пользовательскими параметрами, указав параметры командной строки при запуске скрипта. Для получения дополнительных сведений см. следующий раздел «просмотр информации об использовании скрипта OpenVPN».

В качестве альтернативы можно передать Bash «here document» в качестве входных данных для скрипта установки. Этот метод также можно использовать для передачи входных данных для управления пользователями после установки.

Сначала установите OpenVPN в интерактивном режиме с пользовательскими параметрами и запишите все введённые значения.

```
sudo bash openvpn.sh
```

Если вам нужно удалить OpenVPN, снова запустите скрипт и выберите соответствующий вариант.

Затем создайте команду установки с пользовательскими параметрами, используя ваши ответы. Пример:

```
sudo bash openvpn.sh <<ANSWERS
n
1
1194
2
client
y
ANSWERS
```

**Примечание:** Параметры установки могут измениться в будущих версиях скрипта.
</details>
<details>
<summary>
Просмотреть информацию об использовании скрипта OpenVPN.
</summary>

```
Usage: bash openvpn.sh [options]

Options:

  --addclient [client name]      добавить нового клиента
  --exportclient [client name]   экспортировать конфигурацию для существующего клиента
  --listclients                  показать список существующих клиентов
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

## Следующие шаги

После установки вы можете снова запустить скрипт, чтобы управлять пользователями или удалить OpenVPN.

Настройте ваш компьютер или устройство для использования VPN. Пожалуйста, обратитесь к следующей инструкции:

**[Настройка клиентов OpenVPN](docs/clients.md)**

**Прочитайте [:book: книгу о VPN](docs/vpn-book.md), чтобы получить доступ к [дополнительному контенту](https://ko-fi.com/post/Support-this-project-and-get-access-to-supporter-o-O5O7FVF8J).**

Наслаждайтесь собственным VPN! :sparkles::tada::rocket::sparkles:

## Благодарности

Этот скрипт основан на отличной работе [Nyr и участников проекта](https://github.com/Nyr/openvpn-install) с улучшениями и изменениями для совместимости с проектом [Setup IPsec VPN](https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/README-ru.md).

<details>
<summary>
Список улучшений по сравнению с Nyr/openvpn-install.
</summary>

- Улучшена совместимость с Setup IPsec VPN  
- Повышена надёжность скрипта, улучшены ввод и вывод пользователя  
- Поддержка автоматической установки с параметрами по умолчанию или пользовательскими параметрами  
- Поддержка использования DNS-имени в качестве адреса сервера  
- Добавлена поддержка openSUSE Linux  
- Добавлена поддержка Amazon Linux 2  
- Поддержка экспорта конфигурации для существующего VPN-клиента  
- Поддержка просмотра списка существующих VPN-клиентов  
- Поддержка пользовательских DNS-серверов для VPN-клиентов  
- Поддержка параметров командной строки для управления VPN-клиентами  
- Оптимизация настроек `sysctl` для повышения производительности VPN  
- Улучшено создание файлов конфигурации клиента при использовании `sudo`  

...и многое другое!
</details>

## Лицензия

MIT
