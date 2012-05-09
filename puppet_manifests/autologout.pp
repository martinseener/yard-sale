# == Definition: autologout
#
# Installs a small logout script that local logged in users will be logout after idling for 5min.
# 
# Should work with:
#   - Debian (6.x Squeeze tested)
#   - Ubuntu
#
# === Examples
#
#   include autologout
#
# === Authors
#
# Martin Seener <martin@seener.de>
#
# === License
#
# Open Software License v. 3.0 (OSL-3.0)
# http://www.opensource.org/licenses/OSL-3.0
#
# === Copyright
#
# Copyright 2012 Martin Seener
#
class autologout {
  file { '/etc/profile.d/autologout.sh':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => 644,
    content => "TMOUT=300
                readonly TMOUT
                export TMOUT",
  }
}