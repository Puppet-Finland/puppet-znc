# == Class: znc::install
#
# This class installs znc
#
class znc::install
(
    $ensure

) inherits znc::params
{
    package { $::znc::params::package_name:
        ensure => $ensure,
    }
}
