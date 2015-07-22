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
   rm -rf /etc/fuju/tmp/*
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

CHECKPKGSCREEN=$(pkg info | grep -c "screen")
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



### ### ### ### ### ### ### ### ###
#/ cleanup
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
