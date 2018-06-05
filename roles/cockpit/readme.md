Playbook To Run Cockpit Container on Atomic Host
Configuration
Replace IP_ADDRESS_OF_REMOTE_HOST in Inventory file with the IP Address of your Remote Host. Replace <PRIVATE_KEY_FILE> in ansible_ssh_private_key_file field in Inventory with your Private key file. Replace <USER> in remote_user field in ansible.cfg with the user of your remote host.

Run The Playbook
Now simply run ansible-playbook cockpit.yml.

Visit your IP_Address:9090 on your web browser.

Port:9090 is default PORT of Cockpit Container.

