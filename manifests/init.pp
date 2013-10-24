# = Class heartbeat
#
#   This class manage heartbeat installation and configuration, and creation of resources.
#   N.B: this module assumes that two machines in HA configuration have same network address on the same interfaces
#
# == Parameters
#
# [*debugfile*]
#   log file for debug
#
# [*logfile*]
#   log file
#
# [*logfacility*]
#   facility used on syslog
#
# [*keepalive*]
#   HB keepalive. Default: 2
#
# [*warntime*]
#   HB warntime. Default: 5
#
# [*deadtime*]
#   HB deadtime. Default: 10
#
# [*initdead*]
#   HB initdead. Default: 60
#
# [*udpport*]
#   HB udpport used to monitor nodes. Default: 694
#
# [*interface*]
#   If defined, heartbeat::add_interface define will be declared. This define export a fragment used to monitor the node itself by the other
#
# [*ip_address*]
#   If interface is defined, this address will be used from the other nodes to monitor this node. If not defined, address od $interface will be used
#
# [*auto_failback*]
#   If true enable auto_failback HB feature. Default: false
#
# [*crm*]
#   If true enable use of a CRM to manage resources. Otherwise haresources will be used
#
# [*authkey*]
#   Authkey used by nodes
#
# [*ha_tag*]
#   A tag used for tagging exported resources and to retrieve resources exported by other nodes of the same HA system. Default: $cluster
#
# [*logrotate*]
#   If true enable logrotate for generated logfile. Default: true
#
# [*monitor*]
#   If enabled, enable monitoring of service heartbeat. It use nrpe::check_heartbeat and exporte relied nagios service.
#
# == Examples
#
# We have two node on which we want to manage VIP 192.168.1.100/24 on interface eth0 in HA. For strong reliability heartbeat monitor two interfaces. Suppose to have this two nodes:
#
#  - example01. eth0: 192.168.1.1 - eth1 172.16.1.1
#  - example02. eth0: 192.168.1.2 - eth1 172.16.1.2
#
# Prefered node will be example01. We install heartbeat with all default params
#
#   node clusterexample {
#     # we install and configure heartbeat and VIP resource on both nodes
#     $cluster = 'example'
#     include heartbeat
#
#     heartbeat::VIP {'192.168.1.100':
#       vip       => '192.168.1.100',
#       netmask   => 24,
#       interface => 'eth0',
#       bcast     => '192.168.1.255',
#       pref_node => 'example01'
#     }
#
#     # we add interface to monitor using default. resource name will be recognised as interface name (eth0), interface address will be used (eth0_address)
#     heartbeat::add_interface {'eth0':}
#   }
#
#   # If default params aren't good for us, we add interface/address in each nodes
#
#   node example01 inherts clusterexample {
#     heartbeat::add_interface {'eth1':
#       interface   => 'eth1',
#       address     => '172.16.1.1',
#     }
#   }
#
#   node example02 inherts clusterexample {
#     heartbeat::add_interface {'eth1':
#       interface   => 'eth1',
#       address     => '172.16.1.2',
#     }
#   }
#
#
#
#
class heartbeat (
  $authkey,
  $service_ensure     = running,
  $service_enable     = true,
  $debugfile          = '/var/log/ha.debug',
  $logfile            = '/var/log/ha.log',
  $logfacility        = 'local0',
  $keepalive          = 2,
  $warntime           = 5,
  $deadtime           = 10,
  $initdead           = 60,
  $udpport            = 694,
  $monitor_interface  = '',
  $monitor_ip_address = '',
  $auto_failback      = false,
  $crm                = false,
  $ha_tag             = $cluster,
  $logrotate          = true,
  $monitor            = true,
  $nagios_hostname    = '',
  $file_template      = 'heartbeat/ha.cf.erb',
) {

  include heartbeat::params

  validate_bool($auto_failback)
  validate_bool($crm)
  validate_bool($logrotate)
  validate_bool($monitor)

  if !is_integer($keepalive) {
    fail ('parameter keepalive must be an integer value')
  }

  if !is_integer($warntime) {
    fail ('parameter warntime must be an integer value')
  }

  if !is_integer($deadtime) {
    fail ('parameter deadtime must be an integer value')
  }

  if !is_integer($initdead) {
    fail ('parameter initdead must be an integer value')
  }

  if !is_integer($udpport) {
    fail ('parameter udpport must be an integer value')
  }


  if ( $monitor_ip_address != '' ) and ( $monitor_ip_address !~ /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/ ) {
    fail ('invalid ip_address')
  }

  if ( $monitor_ip_address != '' ) and ( $monitor_interface == '' ) {
    fail('If monitor_ip_address is specified, monitor interface must be also specified')
  }

  if $ha_tag == '' {
    fail ('Please specify ha_tag or define $cluster variable')
  }

  if ( $monitor ) and ( $nagios_hostname == '' ) {
    fail ('if monitor is enabled, $nagios_hostname must be specified')
  }

  $monitorip = $monitor_ip_address ? {
    ''      => $monitor_interface ? {
      ''      => $monitor_ip_address,
      default => inline_template("<%= ipaddress_${interface} %>)"),
    },
    default => $monitor_ip_address
  }

  include heartbeat::install
  include heartbeat::configure
  include heartbeat::service

  Class['heartbeat::install'] ->
  Class['heartbeat::configure'] ->
  Class['heartbeat::service']

}
