=========
yard-sale
=========

Different little Helpers, Scripts and Puppet Manifests and seedbank additions help easing the admins all day life

Nagios Plugins
==============

* check_procurve_ifoperstatus.sh - Checks the Operational Status of one or more ports with the help of Nagios "check_snmp" Plugins which is required. For more Info, check the plugins comments how to use it.
* check_postfix.sh - Checks the Postfix Processes (qmgr, pickup and master) and default smtp port to be up/listening and reports back. More Info in the check`s comments
* check_seedbank.sh - Checks the seedBank Process and default Port separately and reports if each aren`t running/listening.
* check_apt-cacher.sh - Like seedBank but for the APT-Cacher Daemon.

Puppet Manifests
================

* autologout.pp - Creates a small .sh file in /etc/profile.d for auto-logout users after 5min of idle.

Seedbank Additions
==================

* none yet

License and Copyright
=====================

All files are under the Open Software License v. 3.0 (OSL-3.0) (http://www.opensource.org/licenses/OSL-3.0) if not told differently within the file.

Copyright 2012 (c) Martin Seener <martin@seener.de>

Disclaimer
==========

All Code here is written and tested carefully but the author will not be responsible for any loss of data or system corruption.
Use with caution!

Thanks to
=========

* The Puppetlabs Team for giving Puppet to the World