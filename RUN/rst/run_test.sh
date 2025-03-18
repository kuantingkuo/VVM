#!/usr/bin/bash

if [ $(git symbolic-ref --short HEAD) != 'sp' ]; then
    echo 'Git branch not at sp!'
    exit
fi

inif=/data/W.eddie/VVM/CODE/ini_3d_module.F
#for txt in /data/W.eddie/GoAmazon_VVM/inic.txt; do
#for txt in /data/W.eddie/GoAmazon_VVM/inic_const.txt; do #dry inic
for txt in /data/W.eddie/GoAmazon_VVM/inic_lin58.txt; do #theta_e linearly decreases from level 5 to level 8
#    for THs in {2..24..2}; do
    for THs in 14; do
    cd /data/W.eddie/VVM/RUN/rst
    num=06 # time=1min.
    TH=$(printf "%02d" $THs)
    frac=$(printf "%02d" $num)
    runname=GoAmazon_line58_${TH}_t${frac}
    dyn=/data/W.eddie/VVM/DATA/test_bubble_const_${TH}/archive/test_bubble_const_${TH}.L.Dynamic-0000${frac}.nc
    sed -i "519s|\(dynamic_file = \).*$|\1\"${dyn}\"|" $inif

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
