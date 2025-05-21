sudo -E bash /usr/local/bin/sssd.conf.sh
unset LDAP_ADMIN_PASSWORD
sudo service sssd start
