
LICENSE
=======
* BSD 2-Clause

Background
==========
* FreeBSD Unattended Jail Upgrades

Benefits of Goal Setting
========================
* FreeBSD Unattended Jail Upgrades

WARNING
=======
* FuJu is experimental and its not ready for production. Do it at your own risk.

Dependencies
============
* FreeBSD
   * [sysutils/ezjail](https://www.freshports.org/sysutils/ezjail/)
   * [sysutils/screen](https://www.freshports.org/sysutils/screen/)
   * [ports-mgmt/portupgrade](https://www.freshports.org/ports-mgmt/portupgrade/)

* Jail
   * [ports-mgmt/portupgrade](https://www.freshports.org/ports-mgmt/portupgrade/)

* FreeNAS

Features
========
* freebsd [Using pkg for Binary Package Management](https://www.freebsd.org/doc/handbook/pkgng-intro.html)
   * pkg binary support
      * ( if you want to use pkg binary updates? create a "FUJU-PKGBINARY-JAIL" dummy file inside the jail)
```
   touch /FUJU-PKGBINARY-JAIL
```
* freebsd [Using the Ports Collection](https://www.freebsd.org/doc/handbook/ports-using.html)
   * ports support
      * update (ezjail-admin update -P)
      * portupgrade (Upgrading Ports Using Portupgrade)
   * deploying jail subscripts
   * send email notification
      * (if partial finished and need dialog4ports input inside the screen session)
      * require [mail/ssmtp](https://www.freshports.org/mail/ssmtp/) package
   * support for carp jails (BACKUP mode only)

* freenas
   * pkg binary (upgrade) only
   * avoid VirtualBox / Plugin Jails
   * create zfs snapshots before jail upgrading

* freebsd-jail
       * execute pkg version / pkg audit -F
       * execute pkg update / pkg upgrade or portupgrade
       * write logger info

* exclude.conf
   * ignores the listed freebsd jails

usage:
```
   (on FreeBSD):
               # ./fuju.sh freebsd

   (on FreeNAS):
               # ./fuju.sh freenas
```

Platform
========
* FreeBSD
   * 10+

* FreeNAS
   * 9.3+

Usage
=====
```
   WARNING: FreeBSD Unattended Jail Upgrades is experimental and its not ready for production. Do it at your own risk.

   # usage: ./fuju.sh { freebsd | freenas | freebsd-jail }
```

Example
=======
* cronjob (FreeBSD)
```
   vi /etc/crontab

   ### github.com/plitc/fuju // ###
   00      6       *       *       *       root    /bin/sh -c 'cd /github/fuju; /github/fuju/fuju.sh freebsd > /var/log/fuju.log'
   ### // github.com/plitc/fuju ###

   service cron restart
```


* cronjob (FreeNAS)
```
   vi /etc/crontab

   ### github.com/plitc/fuju // ###
   00      6       *       *       *       root    /github/fuju/fuju.sh freenas > /var/log/fuju.log
   ### // github.com/plitc/fuju ###

   service cron restart
```

Example (CARP Jails)
=======
* cronjob for carp jails (FreeBSD)
   * Jail 1 (Master)
```
   vi /etc/crontab

   ### github.com/plitc/fuju // ###
   #// CARP Jail 1 (force BACKUP Mode on Sunday,Monday,Wednesday,Friday)
   55      5       *       *       0,1,3,5 root    /bin/sh -c '/sbin/ifconfig epair106a down; sleep 1; /sbin/ifconfig epair106a up'
   #
   ### // github.com/plitc/fuju ###

   service cron restart
```
* cronjob for carp jails (FreeBSD)
   * Jail 2 (Backup)
```
   vi /etc/crontab

   ### github.com/plitc/fuju // ###
   #// CARP Jail 2 (force BACKUP Mode on Tuesday,Thursday,Saturday)
   55      5       *       *       2,4,6   root    /bin/sh -c '/sbin/ifconfig epair107a down; sleep 1; /sbin/ifconfig epair107a up'
   #
   ### // github.com/plitc/fuju ###

   service cron restart
```

Diagram
=======

Screencast
==========

Errata
======
* 21.07.2015:
```
```

TODO
====
* 02.08.2015: carp jail support for freebsd jails [partial support > Version 0.3.4.5.7]
* 02.08.2015: zfs snapshot support for freebsd jails
* 21.07.2015: --- --- --- initial version --- --- ---

