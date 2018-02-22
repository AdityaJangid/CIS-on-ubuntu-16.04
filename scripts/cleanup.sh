#!/bin/bash -eux

# This shouldn't belong here but beh :-|
cat << EOF > /etc/docker/daemon.json
{
  "debug": true
}
EOF

# Uninstall Ansible and remove PPA.
apt -y remove --purge ansible
apt-add-repository --remove ppa:ansible/ansible

apt-get -y autoremove;
apt-get -y clean;

# Remove docs
rm -rf /usr/share/doc/*

# Remove caches
find /var/cache -type f -exec rm -rf {} \;

# delete any logs that have built up during the install
find /var/log/ -name *.log -exec rm -f {} \;

# Cleaning up tmp
rm -rf /tmp/*

# Cleanup docker
rm -rf /var/lib/ecs/data/*

# Remove bash history
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/ubuntu/.bash_history

# Clear last login information
>/var/log/lastlog
>/var/log/wtmp
>/var/log/btmp