#!/bin/sh

### LICENSE - (BSD 2-Clause) // ###
#
# Copyright (c) 2015, Daniel Plominski (Plominski IT Consulting)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice, this
# list of conditions and the following disclaimer in the documentation and/or
# other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
### // LICENSE - (BSD 2-Clause) ###

### ### ### PLITC // ### ### ###

### stage0 // ###
OSVERSION=$(uname)
FREENAS=$(uname -a | grep -c "ixsystems.com")
JAILED=$(sysctl -a | grep -c "security.jail.jailed: 1")
MYNAME=$(whoami)
DATE=$(date +%Y%m%d-%H%M)
#
PRG="$0"
##/ need this for relative symlinks
while [ -h "$PRG" ] ;
do
   PRG=$(readlink "$PRG")
done
DIR=$(dirname "$PRG")
#
ADIR="$PWD"
#
#/ spinner
spinner()
{
   local pid=$1
   local delay=0.01
   local spinstr='|/-\'
   while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
         local temp=${spinstr#?}
         printf " [%c]  " "$spinstr"
         local spinstr=$temp${spinstr%"$temp"}
         sleep $delay
         printf "\b\b\b\b\b\b"
   done
   printf "    \b\b\b\b"
}
#
#/ function cleanup tmp
cleanup(){
   rm -rf /tmp/fuju_freenas*
}
### // stage0 ###

case "$1" in
'configure')
### stage1 // ###
case $OSVERSION in
FreeBSD)
### stage2 // ###
#
### // stage2 ###

### stage3 // ###
if [ "$MYNAME" = "root" ]; then
   : # dummy
else
   : # dummy
   : # dummy
   echo "[ERROR] You must be root to run this script"
   exit 1
fi
if [ "$JAILED" = "0" ]; then
   : # dummy
else
   : # dummy
   : # dummy
   echo "[ERROR] Run this script on the FreeBSD HOST"
   exit 1
fi
### stage4 // ###
#
### ### ### ### ### ### ### ### ###

if [ "$FREENAS" = "1" ]; then
   : # dummy
   : # dummy
   echo "[ERROR] configure Option isn't for FreeNAS"
   exit 1
else
   : # dummy
fi

CHECKPKGSCREEN=$(pkg info | grep -c "screen-")
if [ "$CHECKPKGSCREEN" = "0" ]; then
   : # dummy
   : # dummy
   echo "[ERROR] You need sysutils/screen"
   exit 1
fi

#/ jail portsnap update
EZJAIL=$(/usr/sbin/pkg info | grep -c "ezjail")
if [ "$EZJAIL" = "1" ]; then
   #// need non-interactive
   (screen -d -m -S PORTUPDATE -- /bin/sh -c '/usr/local/bin/ezjail-admin update -P') & spinner $!
   #// waiting
   (while true; do if [ "$(screen -list | grep -c "PORTUPDATE")" = "1" ]; then sleep 1; else exit 0; fi; done) & spinner $!
else
   #// check freenas os
   if [ "$FREENAS" = "1" ]; then
      : # dummy
   else
      : # dummy
      echo "[ERROR] Environment = unknown"
      exit 1
   fi
fi

#/ deploying subscripts
jls | awk '{print $4}' | egrep -v "Hostname" | xargs -L1 -I % cp -f "$ADIR"/fuju.sh %/root
jls | awk '{print $4}' | egrep -v "Hostname" | xargs -L1 -I % chown root:wheel %/root/fuju.sh
jls | awk '{print $4}' | egrep -v "Hostname" | xargs -L1 -I % chmod 0755 %/root/fuju.sh

CHECKEXCLUDECONF=$(grep -c "" "$ADIR"/exclude.conf)
if [ "$CHECKEXCLUDECONF" = "0" ]; then
   #/ echo "--- --- ---"
   jls | awk '{print $4}' | egrep -v "Hostname" | sed 's/.*\///' | xargs -L1 -I % screen -d -m -S "%" -- /usr/local/bin/ezjail-admin console -e "/root/fuju.sh jail-upgrade" "%"
   #/ echo "--- --- ---"
else
   GETEXCLUDECONF=$(cat "$ADIR"/exclude.conf)
   #/ echo "--- --- ---"
   jls | awk '{print $4}' | egrep -v "Hostname" | egrep -v "$GETEXCLUDECONF" | sed 's/.*\///' | xargs -L1 -I % screen -d -m -S "%" -- /usr/local/bin/ezjail-admin console -e "/root/fuju.sh jail-upgrade" "%"
   #/ echo "--- --- ---"
fi



### ### ### ### ### ### ### ### ###
#/ cleanup
### ### ### ### ### ### ### ### ###
echo "" # printf
printf "\033[1;31mFuJu HOST configuration finished.\033[0m\n"
### ### ### ### ### ### ### ### ###
#
### // stage4 ###
#
### // stage3 ###
#
### // stage2 ###
   ;;
*)
   # error 1
   : # dummy
   : # dummy
   echo "[ERROR] Plattform = unknown"
   exit 1
   ;;
esac
#
### // stage1 ###
;;
'update')
### stage1 // ###
case $OSVERSION in
FreeBSD)
### stage2 // ###
#
### // stage2 ###

### stage3 // ###
if [ "$MYNAME" = "root" ]; then
   : # dummy
else
   : # dummy
   : # dummy
   echo "[ERROR] You must be root to run this script"
   exit 1
fi
if [ "$JAILED" = "0" ]; then
   : # dummy
else
   : # dummy
   : # dummy
   echo "[ERROR] Run this script on the FreeBSD HOST"
   exit 1
fi
### stage4 // ###
#
### ### ### ### ### ### ### ### ###

### FreeNAS // ###
#
if [ "$FREENAS" = "1" ]; then
   : # dummy
   jls | awk '{print $4}' | egrep -v "Hostname" | xargs -L1 -I % find % -name ".plugins" -o -name "1" -maxdepth 1 | sed 's/\/.plugins//' | sed 's/\/1//' > /tmp/fuju_freenas_exclude.txt
   jls | awk '{print $4}' | egrep -v "Hostname" > /tmp/fuju_freenas_all.txt
   cat /tmp/fuju_freenas_all.txt /tmp/fuju_freenas_exclude.txt | sort | uniq -u > /tmp/fuju_freenas_ready.txt
   POSSIBLEJAILS=$(grep -c "" /tmp/fuju_freenas_ready.txt)
   if [ "$POSSIBLEJAILS" = "0" ]; then
      echo "[ERROR] can't find ports jails"
      exit 1
   else
      jls | egrep -v "Hostname" | awk '{print $4,$1}' > /tmp/fuju_freenas_raw.txt
      awk 'NR==FNR {h[$1] = $2; next} {print $1,$2,$3,h[$1]}' /tmp/fuju_freenas_raw.txt /tmp/fuju_freenas_ready.txt | awk '{print $2}' > /tmp/fuju_freenas_run.txt
### SNAPSHOT // ###
      zfs list | awk '{print $5,$1}' > /tmp/fuju_freenas_snap.txt
      awk 'NR==FNR {h[$1] = $2; next} {print $1,$2,$3,h[$1]}' /tmp/fuju_freenas_snap.txt /tmp/fuju_freenas_ready.txt | awk '{print $2}' > /tmp/fuju_freenas_snapshot.txt
      (cat /tmp/fuju_freenas_run.txt | xargs -L1 -I % jexec % /bin/sh -c '/bin/hostname; echo "--- SYNC // ---"; /bin/sync; echo "--- // SYNC ---"') & spinner $!
      echo "" # dummy
      /bin/sync
      cat /tmp/fuju_freenas_snapshot.txt | xargs -L1 -I % zfs snapshot %@_FUJU_$DATE
### // SNAPSHOT ###

### UPGRADE // ###
      echo "" # dummy
      (cat /tmp/fuju_freenas_run.txt | xargs -L1 -I % jexec % /bin/sh -c '/bin/hostname; echo "--- START ---"; /usr/sbin/pkg update; echo "--- END ---"') & spinner $!
      echo "" # dummy
      (cat /tmp/fuju_freenas_run.txt | xargs -L1 -I % jexec % /bin/sh -c '/bin/hostname; echo "--- START ---"; /usr/sbin/pkg upgrade -y; echo "--- END ---"') & spinner $!
      echo "" # dummy
### // UPGRADE ###
   fi
fi
#
### // FreeNAS ###



### ### ### ### ### ### ### ### ###
cleanup
### ### ### ### ### ### ### ### ###
echo "" # printf
printf "\033[1;31mFuJu JAIL updates finished.\033[0m\n"
### ### ### ### ### ### ### ### ###
#
### // stage4 ###
#
### // stage3 ###
#
### // stage2 ###
   ;;
*)
   # error 1
   : # dummy
   : # dummy
   echo "[ERROR] Plattform = unknown"
   exit 1
   ;;
esac
#
### // stage1 ###
;;
'jail-upgrade')
### stage1 // ###
case $OSVERSION in
FreeBSD)
### stage2 // ###
#
### // stage2 ###

### stage3 // ###
if [ "$MYNAME" = "root" ]; then
   : # dummy
else
   : # dummy
   : # dummy
   echo "[ERROR] You must be root to run this script"
   exit 1
fi
if [ "$JAILED" = "1" ]; then
   : # dummy
else
   : # dummy
   : # dummy
   echo "[ERROR] Run this script inside an FreeBSD JAIL"
   exit 1
fi
### stage4 // ###
#
### ### ### ### ### ### ### ### ###

if [ "$FREENAS" = "1" ]; then
   : # dummy
   : # dummy
   echo "[ERROR] jail-upgrade Option isn't for FreeNAS"
   exit 1
else
   : # dummy
fi

### JAIL-UPGRADE // ###
#
CHECKWAITUNG=$(ls -allt / | grep -c "FUJU-WAITING")
if [ "$CHECKWAITUNG" = "0" ]
then
   touch /FUJU-WAITUNG
   echo '< ---- START ---- >'
   /usr/sbin/pkg version -l "<"
   /usr/bin/logger "prepare FreeBSD Unattended Jail Upgrades for $(/usr/sbin/pkg version -l "<" | awk '{print $1}')"
   echo '< ---- ---- ---- >'
   /usr/local/sbin/portupgrade -a
   if [ $? -eq 0 ]
   then
       /usr/bin/logger "FreeBSD Unattended Jail Upgrades finished"
      rm -f /FUJU-WAITUNG
   else
      /usr/bin/logger "unexpected FreeBSD Unattended Jail Upgrades ERROR! (please run portupgrade -a manually and remove /FUJU-WAITUNG)"
   fi
   echo '< ---- END ---- >'
else
   : # dummy
   echo "[ERROR] jail-upgrade always running"
   exit 1
fi
#
### JAIL-UPGRADE // ###



### ### ### ### ### ### ### ### ###
#/ cleanup
### ### ### ### ### ### ### ### ###
echo "" # printf
printf "\033[1;31mFuJu JAIL upgrades finished.\033[0m\n"
### ### ### ### ### ### ### ### ###
#
### // stage4 ###
#
### // stage3 ###
#
### // stage2 ###
   ;;
*)
   # error 1
   : # dummy
   : # dummy
   echo "[ERROR] Plattform = unknown"
   exit 1
   ;;
esac
#
### // stage1 ###
;;
*)
printf "\033[1;31mWARNING: FreeBSD Unattended Jail Upgrades is experimental and its not ready for production. Do it at your own risk.\033[0m\n"
echo "" # usage
echo "usage: $0 { configure | update | jail-upgrade }"
;;
esac
exit 0
### ### ### PLITC ### ### ###
# EOF
