#!/bin/bash
# Author: bongo
# File: bootsummer.sh
# Date: Nov 24 2011

echo -ne "update checksums? [y/N]: "
read update

if echo $update | grep -i "y"; then
  SUMS="$(find /boot -type f -readable 2>&1 | sed s/.*lost\+found.*// | xargs sha512sum )"
  echo "$SUMS"
  for host in $(cat ~/.ssh/sumhosts); do 
     #ssh $host "echo # Calculated on ""$(date +%d_%m_%y)"" | tee bird_boot.sha512sum >/dev/null; echo "$SUMS" | tee bird_boot.sha512sum >/dev/null"
     echo "Checksums uploaded to host ""$host"" which returned status code "`ssh $host "echo '# Calculated on ""$(date +%d_%m_%y)""'|tee bird_boot.sha512sum; echo -e '""$SUMS""' | tee --append bird_boot.sha512sum; echo $?" | tail -1`
  done

else
  for host in $(cat ~/.ssh/sumhosts); do
    echo "checking checksums from host ""$host"
    ssh $host "cat bird_boot.sha512sum" | sha512sum -c
    if [ $? -ne 0 ]; then
      echo "[-] WARNING WARNING WARNING | At least one of the tested checksums was INVALID!!!"
    else
      echo "[+] Test run was successful. No errors detected :)"
    fi
  done
fi

