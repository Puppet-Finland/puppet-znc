# == Define: znc::instance
#
# Set up an instance of ZNC
#
# Note that ZNC configuration is not currently managed by this defined resource. 
# Make sure that whatever parameters you set here make sense for the znc.conf 
# you've created outside Puppet.
#
# == Parameters
#
# [*title*]
#   The resource title is used for the system user ZNC runs as. For example 
#   'john'.
# [*ensure*]
#   Status of this ZNC instance. Valid values are 'present' (default) and 
#   'absent'.
# [*irc_port*]
#   The TCP port on which this ZNC instance listens for incoming IRC 
#   connections. Can be left empty if $::znc::manage_packetfilter is set to 
#   false.
# [*web_port*]
#   The same as above but sets the web (admin) port
# [*web_allow_ipv4*]
#   IPv4 addresses from which to allow web connections. Defaults to '127.0.0.1'.
# [*web_allow_ipv6*]
#   IPv6 addresses from which to allow web connections. Defaults to '::1'.
# [*autostart*]
#   Autostart ZNC and keep it running via cron, as suggested in ZNC 
#   documentation. This is clunky, but also simple and works. Valid values are 
#   true (default) and false.
# [*email*]
#   Email address for server notifications. Defaults to top-scope variable 
#   $::servermonitor.
#
define znc::instance
(
    Optional[Integer]        $irc_port = undef,
    Optional[Integer]        $web_port = undef,
    String                   $web_allow_ipv4 = '127.0.0.1',
    String                   $web_allow_ipv6 = '::1',
    Boolean                  $autostart = true,
    Enum['present','absent'] $ensure = 'present',
    String                   $email = $::servermonitor

)
{
    $system_user = $title

    validate_string($system_user)

    include ::znc::params

    if $autostart {
        # Make sure ZNC is running as suggested in ZNC documentation
        cron { "znc-autostart-${system_user}":
            ensure      => $ensure,
            command     => "${::znc::params::znc_cmd} 2>&1 > /dev/null",
            user        => $system_user,
            minute      => '*/10',
            environment => [ "MAILTO=${email}",
                            'PATH=/bin:/usr/bin' ],
        }
    }

    # Add packet filtering rules for this instance
    if $::znc::manage_packetfilter {

        Firewall {
            ensure   => $ensure,
            chain    => 'INPUT',
            proto    => 'tcp',
            action   => 'accept'
        }

        # Rules for IRC connections
        @firewall { "020 ipv4 accept ${system_user} znc irc on port ${irc_port}":
            provider => 'iptables',
            dport    => $irc_port,
            tag      => 'default',
        }
        @firewall { "020 ipv6 accept ${system_user} znc irc on port ${irc_port}":
            provider => 'ip6tables',
            dport    => $irc_port,
            tag      => 'default',
        }

        # Rules for web (admin) connections
        @firewall { "020 ipv4 accept ${system_user} znc webadmin on port ${web_port}":
            provider => 'iptables',
            dport    => $web_port,
            source   => $web_allow_ipv4,
            tag      => 'default',
        }
        @firewall { "020 ipv6 accept ${system_user} znc webadmin on port ${web_port}":
            provider => 'ip6tables',
            dport    => $web_port,
            source   => $web_allow_ipv6,
            tag      => 'default',
        }
    }
}
