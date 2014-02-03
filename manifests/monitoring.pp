class heartbeat::monitoring (
  $monitored_hostname     = $hostname,
  $notifications_enabled  = undef,
  $notification_period    = undef,
){

  nrpe::check {'heartbeat_link': contrib => true}

  $service_description = $monitored_hostname?{
    $hostname => 'Heartbeat link',
    default   => "${hostname} heartbeat link",
  }

  $nrpe_check = $monitored_hostname?{
    $hostname => '!check_heartbeat_link',
    default   => "!check_heartbeat_link_${hostname}",
  }

  @@nagios::check { "heartbeat-${::hostname}":
    host                  => $monitored_hostname,
    checkname             => 'check_nrpe_1arg',
    service_description   => $service_description,
    notifications_enabled => $notifications_enabled,
    notification_period   => $notification_period,
    target                => "heartbeat_${::hostname}.cfg",
    params                => $nrpe_check,
    tag                   => "nagios_check_heartbeat_${heartbeat::nagios_hostname}",
  }

}
