dir="/home/minecraft/spigot-1.20.2/logs"

start=$SECONDS
sum=""

for f in $dir/*
do
    s=$SECONDS
    log=$(echo $f | cut -b 36-)
    log_date=$(echo $log | cut -b 1-10)
    zcat -f $dir/$log | sed -e "s/\[Async Chat Thread - #[0-9]\+\/INFO]: //" -e "s/^/$log_date /g"
    echo The file $log $(du -h $dir/$log) processed in $(($SECONDS - $s))
done

s=$SECONDS
date_today=$(date +%Y-%m-%d)
cat $dir/latest.log | sed -e "s/\[Async Chat Thread - #[0-9]\+\/INFO]: //" -e "s/^/$date_today /g"
echo The file latest.log processed in $(($SECONDS - $s))

echo Script worked in $(($SECONDS-$start)) seconds
