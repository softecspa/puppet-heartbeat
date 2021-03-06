== HheartBeat Module

This module manage heartbeat installation, configuration, and creation of resources. (at this moment only VIP resources are managed)
N.B: this module assumes that two machines in HA configuration have same network address on the same interfaces

== Example

We suppose have two node on which we want to manage VIP 192.168.1.100/24 on interface eth0 in HA.
- example01. eth0: 192.168.1.1
- example02. eth0: 192.168.1.2

Prefered node will be example01. We install heartbeat with all default params

  node clusterexample {
    # we install and configure heartbeat and VIP resource on both nodes
    $cluster = 'example'

    class {'heartbeat':
      authkey => 'xxXXxx'
      monitor_interface => 'eth0'
    }

    heartbeat::VIP {'192.168.1.100':
       vip       => '192.168.1.100',
       netmask   => 24,
       interface => 'eth0',
       bcast     => '192.168.1.255',
       pref_node => 'example01'
    }
  }
