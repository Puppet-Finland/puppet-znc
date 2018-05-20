# znc

A Puppet module for managing ZNC IRC bouncer on a per-user basis. Has built-in 
firewall support (IPv4 and IPv6).

# Module usage

    include ::znc
    
    # Add a bouncer instance for user "john"
    znc::instance { 'john':
        irc_port       => 4329,
        web_port       => 5329,
        web_allow_ipv4 => '10.0.0.0/8',
        autostart      => true,
    }

For details see [init.pp]((manifests/init.pp) and 
[instance.pp](manifests/instance.pp).
