# == Class: znc::install
#
# This class installs znc
#
class znc::install
(
    Enum['present','absent'] $ensure

) inherits znc::params
{
    package { $::znc::params::package_name:
        ensure => $ensure,
    }
}
