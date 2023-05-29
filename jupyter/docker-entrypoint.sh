#!/bin/bash
set -ex

# USER=$(id -n -u)
# HOME=$(grep ^$USER: /etc/passwd | cut -d: -f6)

echo "Staring up '$USER' on '$HOME'"

sudo service munge start
sudo find $HOME | sudo xargs -d'\n' chown $USER

jupyter lab --no-browser --allow-root --ip=0.0.0.0 --NotebookApp.token='' --NotebookApp.password=''

tail -f /dev/null
