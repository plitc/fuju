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
'freebsd')
### stage1 // ###
case $OSVERSION in
FreeBSD)
### stage2 // ###
#
### // stage2 ###

### stage3 // ###
if [ "$MYNAME" = "root" ]
then
   : # dummy
else
   : # dummy
   : # dummy
   echo "[ERROR] You must be root to run this script"
   exit 1
fi
if [ "$JAILED" = "0" ]
then
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

if [ "$FREENAS" = "1" ]
then
   : # dummy
   : # dummy
   echo "[ERROR] freebsd Option isn't for FreeNAS"
   exit 1
else
   : # dummy
fi

CHECKPKGSCREEN=$(pkg info | grep -c "screen-")
if [ "$CHECKPKGSCREEN" = "0" ]
then
   : # dummy
   : # dummy
   echo "[ERROR] You need sysutils/screen"
   exit 1
fi

#/ jail portsnap update
EZJAIL=$(/usr/sbin/pkg info | grep -c "ezjail")
if [ "$EZJAIL" = "1" ]
then
   #// need non-interactive
   (screen -d -m -S PORTUPDATE -- /bin/sh -c '/usr/local/bin/ezjail-admin update -P') & spinner $!
   #// waiting
   (while true; do if [ "$(screen -list | grep -c "PORTUPDATE")" = "1" ]; then sleep 1; else exit 0; fi; done) & spinner $!
else
   #// check freenas os
   if [ "$FREENAS" = "1" ]
   then
      : # dummy
   else
      : # dummy
      echo "[ERROR] Environment = unknown"
      exit 1
   fi
fi

#/ break
sleep 2

#/ deploying subscripts
jls | awk '{print $4}' | egrep -v "Hostname" | xargs -L1 -I % cp -f "$ADIR"/fuju.sh %/root
jls | awk '{print $4}' | egrep -v "Hostname" | xargs -L1 -I % chown root:wheel %/root/fuju.sh
jls | awk '{print $4}' | egrep -v "Hostname" | xargs -L1 -I % chmod 0755 %/root/fuju.sh

CHECKEXCLUDECONF=$(grep -c "" "$ADIR"/exclude.conf)
if [ "$CHECKEXCLUDECONF" = "0" ]
then
   #/ echo "--- --- ---"
   jls | awk '{print $4}' | egrep -v "Hostname" | sed 's/.*\///' | xargs -L1 -I % screen -d -m -S "%" -- /usr/local/bin/ezjail-admin console -e "/root/fuju.sh freebsd-jail" "%"
   #/ echo "--- --- ---"
else
   GETEXCLUDECONF=$(cat "$ADIR"/exclude.conf)
   #/ echo "--- --- ---"
   jls | awk '{print $4}' | egrep -v "Hostname" | egrep -v "$GETEXCLUDECONF" | sed 's/.*\///' | xargs -L1 -I % screen -d -m -S "%" -- /usr/local/bin/ezjail-admin console -e "/root/fuju.sh freebsd-jail" "%"
   #/ echo "--- --- ---"
fi

### check DIALOG // ###
#
CHECKWAITING=$(jls | awk '{print $4}' | egrep -v "Hostname" | xargs -L1 -I % find % -name "FUJU-DIALOG" -maxdepth 1 | sed 's/\/FUJU-DIALOG//' | grep -c "")
if [ "$CHECKWAITING" = "0" ]
then
   echo "" # printf
   printf "\033[1;31mFuJu for FreeBSD finished.\033[0m\n"
else
   echo "" # dummy
   echo "[WARNING] some jails waiting for manually dialog input"
   echo "" # dummy
   jls | awk '{print $4}' | egrep -v "Hostname" | xargs -L1 -I % find % -name "FUJU-DIALOG" -maxdepth 1 | sed 's/\/FUJU-DIALOG//'
   echo "" # dummy
   screen -ls
   echo "" # dummy
   #/ send email notification
   CHECKPKGSSMTP1=$(pkg info | grep -c "ssmtp")
   if [ "$CHECKPKGSSMTP1" = "1" ]
   then
      #// normal notification
      echo "" > /tmp/fuju_mail.txt
      echo "need manually dialog input:" >> /tmp/fuju_mail.txt
      echo "" >> /tmp/fuju_mail.txt
      jls | awk '{print $4}' | egrep -v "Hostname" | xargs -L1 -I % find % -name "FUJU-DIALOG" -maxdepth 1 | sed 's/\/FUJU-DIALOG//' >> /tmp/fuju_mail.txt
      echo "--- --- --- --- --- --- --- --- ---" >> /tmp/fuju_mail.txt
      screen -ls >> /tmp/fuju_mail.txt
      mail -s "FreeBSD Unattended Jail Upgrades: (partial) finished!" root < /tmp/fuju_mail.txt
      rm -f /tmp/fuju_mail.txt
   fi
   echo "" # printf
   printf "\033[1;33mFuJu for FreeBSD (partial) finished.\033[0m\n"
fi
#
### // check DIALOG ###

### check ERROR // ###
#
CHECKJAILERROR=$(jls | awk '{print $4}' | egrep -v "Hostname" | xargs -L1 -I % find % -name "FUJU-ERROR" -maxdepth 1 | sed 's/\/FUJU-ERROR//' | grep -c "")
if [ "$CHECKJAILERROR" = "0" ]
then
   : # dummy
else
   echo "" # dummy
   echo "[WARNING] some jails got an error in the last upgrade process"
   echo "" # dummy
   jls | awk '{print $4}' | egrep -v "Hostname" | xargs -L1 -I % find % -name "FUJU-ERROR" -maxdepth 1 | sed 's/\/FUJU-ERROR//'
   echo "" # dummy
   #/ send email notification on error
   CHECKPKGSSMTP2=$(pkg info | grep -c "ssmtp")
   if [ "$CHECKPKGSSMTP2" = "1" ]
   then
      #// error notification
      echo "" > /tmp/fuju_mail_error.txt
      echo "[ERROR] Jails:" >> /tmp/fuju_mail_error.txt
      echo "" >> /tmp/fuju_mail_error.txt
      jls | awk '{print $4}' | egrep -v "Hostname" | xargs -L1 -I % find % -name "FUJU-ERROR" -maxdepth 1 | sed 's/\/FUJU-ERROR//' >> /tmp/    fuju_mail_error.txt
      echo "--- --- --- --- --- --- --- --- ---" >> /tmp/fuju_mail_error.txt
      echo "" >> /tmp/fuju_mail_error.txt
      echo "unexpected errors (please run portupgrade -a manually and remove the lock files /FUJU-LOCKED and may be /FUJU-ERROR)" >> /tmp/fuju_mail_error.txt
      mail -s "FreeBSD Unattended Jail Upgrades: ERROR Jails!" root < /tmp/fuju_mail_error.txt
      rm -f /tmp/fuju_mail_error.txt
   fi
fi
#
### // check ERROR ###



### ### ### ### ### ### ### ### ###
#/ cleanup
### ### ### ### ### ### ### ### ###
#/ echo "" # printf
#/ printf "\033[1;31mFuJu for FreeBSD finished.\033[0m\n"
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
'freenas')
### stage1 // ###
case $OSVERSION in
FreeBSD)
### stage2 // ###
#
### // stage2 ###

### stage3 // ###
if [ "$MYNAME" = "root" ]
then
   : # dummy
else
   : # dummy
   : # dummy
   echo "[ERROR] You must be root to run this script"
   exit 1
fi
if [ "$JAILED" = "0" ]
then
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
if [ "$FREENAS" = "1" ]
then
   : # dummy
   jls | awk '{print $4}' | egrep -v "Hostname" | xargs -L1 -I % find % -name ".plugins" -o -name "1" -maxdepth 1 | sed 's/\/.plugins//' | sed 's/\/1//' > /tmp/fuju_freenas_exclude.txt
   jls | awk '{print $4}' | egrep -v "Hostname" > /tmp/fuju_freenas_all.txt
   cat /tmp/fuju_freenas_all.txt /tmp/fuju_freenas_exclude.txt | sort | uniq -u > /tmp/fuju_freenas_ready.txt
   POSSIBLEJAILS=$(grep -c "" /tmp/fuju_freenas_ready.txt)
   if [ "$POSSIBLEJAILS" = "0" ]
   then
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
else
   echo "[ERROR] freenas Option isn't for FreeBSD"
   exit 1
fi
#
### // FreeNAS ###



### ### ### ### ### ### ### ### ###
cleanup
### ### ### ### ### ### ### ### ###
echo "" # printf
printf "\033[1;31mFuJu for FreeNAS finished.\033[0m\n"
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
'freebsd-jail')
### stage1 // ###
case $OSVERSION in
FreeBSD)
### stage2 // ###
#
### // stage2 ###

### stage3 // ###
if [ "$MYNAME" = "root" ]
then
   : # dummy
else
   : # dummy
   : # dummy
   echo "[ERROR] You must be root to run this script"
   exit 1
fi
if [ "$JAILED" = "1" ]
then
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

if [ "$FREENAS" = "1" ]
then
   : # dummy
   : # dummy
   echo "[ERROR] freebsd-jail Option isn't for FreeNAS"
   exit 1
else
   : # dummy
fi

### check DIALOG // ###
#
CHECKDIALOG4PORTS=$(ps -ax | grep "/usr/local/bin/dialog4ports" | egrep -cv "grep")
if [ "$CHECKDIALOG4PORTS" = "0" ]
then
   : # dummy
else
   touch /FUJU-DIALOG
   #/ exit 1
fi
#
### // check DIALOG ###

### JAIL-UPGRADE // ###
#
CHECKLOCKFILE=$(ls -allt / | grep -c "FUJU-LOCKED")
if [ "$CHECKLOCKFILE" = "0" ]
then
   CHECKCARPJAIL=$(/sbin/ifconfig | grep -c "carp")
   if [ "$CHECKCARPJAIL" = "0" ]
   then
      #/ non-carp jail
      touch /FUJU-LOCKED
      echo '< ---- START ---- >'
      /usr/sbin/pkg version -l "<"
      #/ /usr/bin/logger "FreeBSD Unattended Jail Upgrades: prepare for $(/usr/sbin/pkg version -l "<" | awk '{print $1}')"
      /usr/bin/logger "FreeBSD Unattended Jail Upgrades: prepare for $(if [ -z "$(/usr/sbin/pkg version -l "<" | awk '{print $1}')" ]; then echo "nothing"; else echo "$(/usr/sbin/pkg version -l "<" | awk '{print $1}')"; fi)"
      echo '< ---- ---- ---- >'
      /usr/local/sbin/portupgrade -a
      if [ $? -eq 0 ]
      then
         /usr/bin/logger "FreeBSD Unattended Jail Upgrades: finished"
         rm -f /FUJU-ERROR
         rm -f /FUJU-LOCKED
         rm -f /FUJU-DIALOG
         #// restart jail services
         CHECKJAILSERVICES=$(/usr/sbin/service -e | grep '/usr/local/etc/rc.d' | sed 's/\/usr\/local\/etc\/rc.d\///' | grep -c "")
         if [ "$CHECKJAILSERVICES" = "0" ]
         then
            : # dummy
         else
            /usr/bin/logger "FreeBSD Unattended Jail Upgrades: restart services"
            /usr/sbin/service -e | grep '/usr/local/etc/rc.d' | sed 's/\/usr\/local\/etc\/rc.d\///' | xargs -L1 -I % service % restart
         fi
      else
         touch /FUJU-ERROR
         /usr/bin/logger "[ERROR] FreeBSD Unattended Jail Upgrades: unexpected error (please run portupgrade -a manually and remove the lock files /FUJU-LOCKED and may be /FUJU-ERROR)"
      fi
      echo '< ---- END ---- >'
   else
      #/ carp jail
      : # dummy
   fi
else
   /usr/bin/logger "[ERROR] FreeBSD Unattended Jail Upgrades: always running"
   echo "[ERROR] FreeBSD Unattended Jail Upgrades: always running"
   exit 1
fi
#
### // JAIL-UPGRADE ###



### ### ### ### ### ### ### ### ###
#/ cleanup
### ### ### ### ### ### ### ### ###
echo "" # printf
printf "\033[1;31mFuJu FreeBSD JAIL upgrades finished.\033[0m\n"
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
echo "usage: $0 { freebsd | freenas | freebsd-jail }"
;;
esac
exit 0
### ### ### PLITC ### ### ###
# EOF
