# == Class: znc
#
# This class sets up znc
#
# Currently functionality is limited to managing the package and setting up 
# autostart (cronjobs) and packet filtering rules for ZNC instances. Actual 
# configuration of ZNC is outside the scope of this module for now.
#
# == Parameters
#
# [*manage*]
#   Whether to manage znc using Puppet. Valid values are true (default) 
#   and false.
# [*manage_packetfilter*]
#   Whether to manage znc packet filtering using Puppet. This parameter is only 
#   used indirectly by znc::instance resources. Valid values are true (default) 
#   and false.
# [*ensure*]
#   Status of znc. Valid values are 'present' (default) and 'absent'. 
# [*instances*]
#   A hash of ::znc::instance resources to realize.
#
# == Authors
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class znc
(
    $manage = true,
    $manage_packetfilter = true,
    $ensure = 'present',
    $instances = {}

) inherits znc::params
{

validate_bool($manage)
validate_bool($manage_packetfilter)
validate_re("${ensure}", '^(present|running|absent)$')

if $manage {

    class { '::znc::install':
        ensure => $ensure,
    }

    # Create ZNC instances
    create_resources('znc::instance', $instances)

}
}
