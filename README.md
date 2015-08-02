
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
* configure
   * ezjail-admin update -P (FreeBSD)
   * deploying subscripts (FreeBSD)

* update
   * pkg upgrade (FreeNAS)
   * avoid VirtualBox / Plugin Jails (FreeNAS)
   * create zfs snapshots before jail upgrading (FreeNAS)

* jail-upgrade
       * execute pkg version -l (FreeBSD)
       * execute portupgrade -a (FreeBSD)
       * write logger info (FreeBSD)

* exclude.conf
   * ignores the listed jails

usage:
```
   on FreeBSD: ./fuju.sh configure

   on FreeNAS: ./fuju.sh update
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

   # usage: ./fuju.sh { configure | update | jail-upgrade }
```

Example
=======
* configure
   * @HOST (FreeBSD)
```
   vi /etc/crontab

   ### github.com/plitc/fuju // ###
   00      6       *       *       *       root    /github/fuju/fuju.sh configure > /var/log/fuju.log
   ### // github.com/plitc/fuju ###

   service cron restart
```
   * @HOST (FreeNAS)
```
   vi /etc/crontab

   ### github.com/plitc/fuju // ###
   00      6       *       *       *       root    /github/fuju/fuju.sh update > /var/log/fuju.log
   ### // github.com/plitc/fuju ###

   service cron restart
```

* update
```
```

* jail-upgrade
```
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
* 21.07.2015:

