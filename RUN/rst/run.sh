#!/usr/bin/bash

if [ $(git symbolic-ref --short HEAD) != 'sp' ]; then
    echo 'Git branch not at sp!'
    exit
fi

for dir in /data/W.eddie/VVM/DATA/20141124T????; do
    cd /data/W.eddie/VVM/RUN/rst
    datetime=$(basename "$dir")
    runname=${datetime}_run

    echo $datetime
    if [ -e /data/W.eddie/VVM/DATA/${runname} ];then
        echo "$runname exist! SKIP!"
        continue
    fi

    file=/data/W.eddie/GoAmazon/Congo_${datetime}.txt
    sed -i "8s|\(set expname = \).*|\1${runname}|" vvm.setup
    sed -i "s|\(set inic = \).*|\1${file}|" vvm.setup
    temp=$(ls -t ${dir}/archive | head -n 1)
    suf=${temp#*-}
    thrm=${dir}/archive/${datetime}.L.Thermodynamic-${suf}
    dynm=${dir}/archive/${datetime}.L.Dynamic-${suf}
    sed -i "s|\(set rst_thrm = \).*|\1${thrm}|" vvm.setup
    sed -i "s|\(set rst_dynm = \).*|\1${dynm}|" vvm.setup
    sed -i "16s|\(set expname = \).*|\1${runname}|" vvm.run

    ./vvm.setup
    ./vvm.run
    cd /data/W.eddie/VVM/DATA/${runname}
    sbatch run.sh
done
