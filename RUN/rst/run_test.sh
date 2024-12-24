#!/usr/bin/bash

if [ $(git symbolic-ref --short HEAD) != 'sp_bubble' ]; then
    echo 'Git branch not at sp_bubble!'
    exit
fi

inif=/data/W.eddie/VVM/CODE/ini_3d_module.F
#for txt in /data/W.eddie/GoAmazon_VVM/inic.txt; do
for txt in /data/W.eddie/GoAmazon_VVM/inic_const.txt; do #dry inic
    for num in {2..24..2}; do
    cd /data/W.eddie/VVM/RUN/rst
    frac=$(printf "%02d" $num)
#    runname=tst
    runname=test_bubble_const_${frac}
    sed -i "446s|\S\+\.|${num}.|" $inif

    if [ -e /data/W.eddie/VVM/DATA/${runname} ];then
        echo "/data/W.eddie/VVM/DATA/$runname exist! REMOVE DIR.!"
        /usr/bin/rm -rf "/data/W.eddie/VVM/DATA/$runname"
    fi

    file="${txt}"
    sed -i "8s|\(set expname = \).*|\1${runname}|" vvm.setup
    sed -i "s|\(set inic = \).*|\1${file}|" vvm.setup
#    temp=$(ls -t ${dir}/archive | head -n 1)
#    suf=${temp#*-}
    sed -i "16s|\(set expname = \).*|\1${runname}|" vvm.run

    ./vvm.setup
    ./vvm.run
    cd /data/W.eddie/VVM/DATA/${runname}
    sbatch run.sh
    done
done
