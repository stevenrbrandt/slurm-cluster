#!/bin/bash
# Make sure cron is running
echo starting up
for f in passwd shadow group
do
    if [ ! -r /home/$f ]
    then
        cp /etc/$f /home/$f
    fi
done

if [ -r /install/certs/etk.cct.lsu.edu.cer ]
then
   mkdir -p /etc/ssl/certs
   cp /install/certs/etk.cct.lsu.edu.cer /etc/ssl/certs/etk.cct.lsu.edu.cer
fi

if [ -r /install/private/etk.cct.lsu.edu.key ]
then
   mkdir -p /etc/ssl/private
   chmod 700 /etc/ssl/private
   cp /install/private/etk.cct.lsu.edu.key /etc/ssl/private/etk.cct.lsu.edu.key
fi

sudo service munge start
randpass MND | grep pass: | cut -f2 -d: | sed 's/\s//g' > /usr/enable_mkuser
echo "STARTUP CODE: $(cat /usr/enable_mkuser)"

cd /

python3 /usr/local/bin/make_users.py
if [ -r /home/shadow ]
then
    cp /home/shadow /etc/shadow
fi

jupyterhub --ip 0.0.0.0 --port 443 -f jup-config.py 2>&1 | tee /var/log/jup-log.txt
