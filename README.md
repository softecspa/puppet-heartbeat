puppet-heartbeat
================

This module manages heartbeat installation, configuration and resources creation.
This module assume that two machines in HA configuration have same network address on the same interfaces.

## Install

        class {'heartbeat':
          debugfile     => '/var/log/ha.debug',
          logfile       => '/var/log/ha.log',
          logfacility   => 'local0',
          keepalive     => 2,
          warntime      => 5,
          deadtime      => 10,
          initdead      => 60,
          udpport       => 694,
          interface     => 'eth0',
          ip_address    => '192.168.1.1', #if not specified, ip address of selected interface will be used
          auto_failback => false,
          crm           => false,
          tag           => $cluster,
        }


This class install and configure heartbeat. After, it export a fragment:

        concat_fragment {'ha.cf_$identifiers':
            content => inline_template('node <%= hostname %>'),
            tag     => "HB_node_$tag",
        }

and import exported resources

 - type Heartbeat::Interface tagged with HB_interface_$tag and where hostname != $hostname
 - type concat_fragment tagged with HB_node_$tag

#### Add interface to check.
This define add interface to the heartbeat monitor.

        heartbeat::add_interface {'eth0':
          interface =>  'eth0',         #if not specified <name> will be used
          address   =>  '192.168.X.X'   #if not specified ip address of specified interface will be used
        }

this define export a define configuration's fragment like this

        @@heartbeat::interface {
          interface   => eth0,
          address     => '192.168.X.X',
          node        => $hostname,
          tag         => HB_interface_$tag,
        }

## Adding resources

#### Add VIP
This define add a VIP address to resources managed by heartbeat

        heartbeat::VIP { 'VIP_name':
          vip       => '192.168.1.X',
          netmask   => 24,
          interface => 'eth0',
          bcast     => '192.168.1.255',
          pref_node => 'botolo01'
        }
