# = Define: heartbeat::monitored_interface
#
# Add interface for monitoring status by other nodes
#
# == Parameter
#
# [*interface*]
#   interface through address have to be monitored. If not defined <name> will be used
#
# [*address*]
#   Ip address to monitor. If not defined interface's address will be used
#
# [*file_template*]
#   Template for overriding default
#
#
define heartbeat::monitored_interface (
  $interface      = '',
  $address        = '',
  $file_template  = 'heartbeat/monitored_interface.erb',
  $ha_tag         = $cluster
){

  if !defined(Class['heartbeat']) {
    fail('class heartbeat must be included')
  }

  if $ha_tag == '' {
    fail('please specify ha_tag or $cluster variable')
  }

  $monitored_interface = $interface ? {
    ''      => $name,
    default => $interface,
  }

  if inline_template("<%= ipaddress_${monitored_interface} %>") == '' {
    fail("interface name ${monitored_interface} doesn't have any ip address")
  }

  $monitored_address = $address ? {
    ''      => inline_template("<%= ipaddress_${monitored_interface} %>"),
    default => $address,
  }

  if $monitored_address !~ /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/ {
    fail('Invalid address was specified')
  }

  @@heartbeat::interface { "${name}-${hostname}" :
    interface   => $monitored_interface,
    address     => $monitored_address,
    nodename    => $hostname,
    ha_tag      => $ha_tag,
  }
}
