while true
do
    for f in passwd shadow group
    do
        while [ ! -r /home/$f ]
        do
            sleep 5
        done
        cp /home/$f /etc/$f
        sleep 10
    done
done
