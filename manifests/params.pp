#
# == Class: znc::params
#
# Defines some variables based on the operating system
#
class znc::params {

    case $::osfamily {
        'Debian': {
            $package_name = 'znc'
            $znc_cmd = '/usr/bin/znc'
        }
        default: {
            fail("Unsupported OS: ${::osfamily}")
        }
    }
}
