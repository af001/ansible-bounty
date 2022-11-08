# Ansible Bounty
> A set of ansible playbooks to setup a bug bounty Linux environment and personal Interactsh server on a VPS.

![Ansible Version][ansible-image]
![Supported OS][debian-version]

A set of Ansible playbooks to build a fresh bug bounty tools build on Debian 11. The playbooks also include options to build a personal interactsh-server for OOB testing. 

## Requirements
1 x Debian VPS for attack machine build
1 x Debian VPS for interactsh-server build (optional) w/domain
1 x Debian VPS for interactsh-web build (optional) w/domain

For interactsh-server, you mush be able to modify your DNS zone file to add additional TXT and A records. SSL certs are obtained using certbot.

## Installation
Each playbook will run tasks from the common role to setup a baseline environment on the Debian VPS. 

Linux:

```sh
apt update && apt -y install ansible
```

OSX:
```sh
brew install ansible
```

Fetch this project:
```sh
git clone https://github.com/af001/ansible-bounty.git
cd ansible-bounty
```

Modify inventory:
```sh
vi inventory.ini
```

For interactsh-server, modify vars.yml to include your domain:
```sh
vim roles/interactshserver/vars/main.yml
```

For interactsh-web, modify vars.yml to include your domain:
```sh
vim roles/interactshweb/vars/main.yml
```

Run a playbook based on selection:
```sh
ansible-playbook build-attack.yml -i inventory.ini
```

Once complete, you can SSH to the hosts. The build will generate a random-high SSH port that will be displayed in the ansible output. Each build sets a default set of Iptable rules to help protect the server when it is not used. When running the interactsh builds, there is a start.sh file in the root of each host. This file will start the container and modify the rules appropriately. By default, the first time you login your IP address will be set as the only allowable SSH host to further harden the VPS. 

## DNS Settings
The interactsh-server will need a wildcard A record so the random generated URLs resolve to your server. 
```
*.example.com
```

<!-- Markdown link & img dfn's -->
[ansible-image]: https://img.shields.io/badge/Ansible-2.13.5-blue
[debian-version]: https://img.shields.io/badge/Debian-11-green

