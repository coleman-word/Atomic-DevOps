Replace IP_OF_ATOMIC_HOST and PRIVATE_KEY_FILE in inventory with the IP of your Atomic host and ssh private key file of your workstation respectively.

Run the playbook after that.

$ ansible-playbook remote-access.yml
Make sure tcp port 2376 in opened of your atomic instance. If you are using Openstack, add the tcp port in your security rule. Reboot both of your Atomic host(Docker Daemon host) and Workstation(Docker Client host).

So now if you try running any docker command as regular user on your workstation it will talk to the docker daemon of the Atomic host and execute the command there. You do not need to manually ssh and issue docker command on your Atomic host.