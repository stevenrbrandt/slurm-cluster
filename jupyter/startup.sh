#!/bin/bash
# Make sure cron is running
echo starting up

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

cd /etc/skel

tar xzf /home/sbrandt/skel.tgz

cd /

# If we have password data saved, use it
for f in passwd shadow group
do
    if [ -r /home/$f ]
    then
        cp -p /home/$f /etc/$f
    fi
done

# Find user accounts not in /etc/passwd and create them
python3 /usr/local/bin/make_users.py

# Start the relinker, copying passwd data to home
nohup bash /relink.sh &

jupyterhub --ip 0.0.0.0 --port 443 -f jup-config.py 2>&1 | tee /var/log/jup-log.txt
