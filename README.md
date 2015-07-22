
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

* update
   * pkg upgrade (FreeNAS)

* jail-upgrade

usage:
```
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
   * @HOST (FreeBSD/FreeNAS)
```
   vi /etc/crontab

   ### github.com/plitc/fuju // ###
   00 6   * * *   root   /github/fuju/fuju.sh
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

