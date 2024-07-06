#!/usr/bin/bash

if [ $(git symbolic-ref --short HEAD) != 'sp_ndg' ]; then
    echo 'Git branch not at sp_ndg!'
    exit
fi

for file in /data/W.eddie/GoAmazon/Congo_20141124T????.txt; do
    cd /data/W.eddie/VVM/RUN/ndg
    filename=$(basename "$file")
    temp="${filename#Congo_}"
    datetime="${temp%.txt}"

    echo $datetime
    if [ -e /data/W.eddie/VVM/DATA/${datetime} ];then
        echo "$datetime exist! SKIP!"
        continue
    fi
    sed -i "8s|\(set expname = \).*|\1$datetime|" vvm.setup
    sed -i "s|\(set inic = \).*|\1${file}|" vvm.setup
    sed -i "16s|\(set expname = \).*|\1$datetime|" vvm.run

    ./vvm.setup
    ./vvm.run
    cd /data/W.eddie/VVM/DATA/${datetime}
    sbatch run.sh
done
