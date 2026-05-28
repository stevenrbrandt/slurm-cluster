umask 022
cp /etc/hosts /etc/hosts0
while true
do
    # munge key
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

    # slurm conf
    diff /home/etuser/slurm.conf /etc/slurm/slurm.conf
    if [ $? = 1 ]; then
        cp /home/etuser/slurm.conf /etc/slurm/slurm.conf
        scontrol reconfigure
        if [ "$(hostname)" = "slurmmaster" ]; then
            sudo service slurmctld restart
        else
            sudo service slurmd restart
        fi
    fi

    # /etc/hosts
    grep $(hostname) /etc/hosts0 > /home/$(hostname).host.txt
    grep -v $(hostname) /etc/hosts0 > /etc/hosts1
    cat /home/*.host.txt >> /etc/hosts1
    diff /etc/hosts1 /etc/hosts
    if [ $? != 0 ]; then
        cat /etc/hosts1 > /etc/hosts
    fi

    # passwds
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
