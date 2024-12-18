#!/usr/bin/bash

if [ $(git symbolic-ref --short HEAD) != 'sp' ]; then
    echo 'Git branch not at sp!'
    exit
fi

inif=/data/W.eddie/VVM/CODE/ini_3d_module.F
#for txt in /data/W.eddie/GoAmazon_VVM/inic.txt; do
for txt in /data/W.eddie/GoAmazon_VVM/inic_const.txt; do #dry inic
    for num in {195..195}; do
    cd /data/W.eddie/VVM/RUN/rst
    frac=0.$num
#    runname=tst
    runname=test_${frac}circulation_const_WL6_08
    sed -i "588,589s|\*.*$|\*${frac}|" $inif

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
