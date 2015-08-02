
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
* freebsd
   * ezjail-admin update -P (Ports)
   * portupgrade (Self-Contained Application Packaging)
   * deploying subscripts
   * send email notification
      * (if partial finished and need dialog4ports input inside the screen session)
      * require [mail/ssmtp](https://www.freshports.org/mail/ssmtp/) Package

* freenas
   * pkg upgrade (binary)
   * avoid VirtualBox / Plugin Jails
   * create zfs snapshots before jail upgrading

* freebsd-jail
       * execute pkg version -l
       * execute portupgrade -a
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
   00      6       *       *       *       root    /github/fuju/fuju.sh freebsd > /var/log/fuju.log
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
* 02.08.2015: carp jail support for freebsd jails
* 02.08.2015: zfs snapshot support for freebsd jails
* 21.07.2015: --- --- --- initial version --- --- ---

