# Ansible Bounty
> A set of ansible playbooks to setup a bug bounty Linux environment and personal Interactsh server on a Linode VPS.

![Ansible Version][ansible-image]
![Supported OS][debian-version]
![Wireguard][wireguard-badge]
![VPS][linode-badge]
![Bounty][bug-bounty]

A set of Ansible playbooks to build a fresh bug bounty tools build on Debian 11. The playbooks also include options to build a personal interactsh-server for OOB testing and a wireguard server for remote to on-prem access. 

## Requirements
Domains are required for some builds to secure web applications and for interactsh-server functionality. 
* 1 x Debian VPS for attack machine build
* 1 x Debian VPS for interactsh-server build w/domain
* 1 x Debian VPS for interactsh-web build  w/domain
* 1 x Debian VPS for wireguard build w/domain
* Linode API Token

For interactsh-server, you mush be able to modify your DNS zone file to add additional TXT and A records. SSL certs are obtained using certbot.

## Installation
The master playbook will initialize Linode instances and run tasks based on the number and type of infrastructure you need. The common role is installed on each host and creates a baseline environment. Once complete, the additional roles are used to setup the specific tools and web applications. Ansible should be installed on your local machine. This can be done using apt or brew depending on your host OS. 

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

Generate a vault-pass file that contains the key used to encrypt files and variables. Replace the values between `<>` with your password.
```sh
echo "<my-super-secret-password>" > .vault_pass
chmod 600 .vault-pass
```

Using the vault-pass file to encrypt your SSH public key, Linode API token, and SSH password. Replace the values between `<>` with your values. 
```sh
# Add new line at end of main.yml
echo "" >> roles/linode/vars/main.yml

# Linode API Token
ansible-vault encrypt_string '<replace-with-your-Linode-API-token' --name 'api_token' --vault-password-file=.vault_pass | tee -a roles/linode/vars/main.yml

# Add new line at end of main.yml
echo "" >> roles/linode/vars/main.yml

# Root SSH Password
ansible-vault encrypt_string '<replace-with-your-ssh-password>' --name 'password' --vault-password-file=.vault_pass | tee -a roles/linode/vars/main.yml

# Add new line at end of main.yml
echo "" >> roles/linode/vars/main.yml

# SSH Public Key
ansible-vault encrypt_string '<replace-with-your-ssh-public_key>' --name 'pubkey' --vault-password-file=.vault_pass | tee -a roles/linode/vars/main.yml
```

Modify the number and type of Linodes you want to deploy. 

```sh
vim roles/linode/vars/main.yml
```

Any instance with a value of 0 will skip that type of node from being deployed. The following example would deploy only 1 Linode with wireguard.

```sh
vim roles/linode/vars/main.yml

--- snippet ---

attack:
  instances: 0
  region: us-central
  type: g6-nanode-1
  label: "attack"
  tag: attack

iserver:
  instances: 0
  region: us-central
  type: g6-nanode-1
  label: "interactsh-server"
  tag: iserver

iweb:
  instances: 0
  region: us-central
  type: g6-standard-1
  label: "interactsh-web"
  tag: iweb

wireguard:
  instances: 1
  region: us-central
  type: g6-nanode-1
  label: "wireguard"
  tag: wireguard

```
Modify the location `group_vars/all.yml` to update the location of your private key on your host. This should be the matching private key to the public key that was referenced earlier. 

```sh
vim group_vars/all.yml

--- snippet ---

ansible_ssh_private_key_file: <path-to-your-privkey>

```

For interactsh-server, modify vars.yml to include your domain:
```sh
vim roles/interactshserver/vars/main.yml
```

For interactsh-web, modify vars.yml to include your domain:
```sh
vim roles/interactshweb/vars/main.yml
```

For wireguard, modify vars.yml to include your domain:
```sh
vim roles/wireguard/vars/main.yml
```

Run the master playbook:
```sh
ansible-playbook --vault-password-file=.vault_pass build-master.yml -K
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
[linode-badge]: https://img.shields.io/badge/VPS-Linode-brightgreen
[wireguard-badge]: https://img.shields.io/badge/VPN-Wireguard-red
[bug-bounty]: https://img.shields.io/badge/Bug-Bounty-lightgrey