umask 022
while true
do
    if [ ! -r /home/munge.key ]; then
        if [ "$(hostname)" = "slurmmaster" ]; then
            umask 077
            dd if=/dev/random bs=1 count=1024 > /home/munge.key_
            umask 022
            chown munge:munge /home/munge.key_
            mv /home/munge.key_ /home/munge.key
        fi
        cp /home/munge.key /etc/munge/munge.key
    else
        if ! diff /home/munge.key /etc/munge/munge.key > /dev/null; then
        cp /home/munge.key /etc/munge/munge.key
        fi
    fi
    if [ "$(hostname)" = "slurmjupyter" ]; then
        for f in passwd shadow group
        do
            if ! diff /home/$f /etc/$f > /dev/null; then
                cp /etc/$f /home/$f
            fi
        done
    else
        for f in passwd shadow group
        do
            if ! diff /home/$f /etc/$f > /dev/null; then
                cp /home/$f /etc/$f
            fi
        done
    fi
    sleep 20
done
