class heartbeat::monitoring {

  nrpe::check {'heartbeat_link': contrib => true}

  @@nagios::check { "heartbeat-${::hostname}":
    host                  => $hostname,
    checkname             => 'check_nrpe_1arg',
    service_description   => "Heartbeat link",
    notifications_enabled => 0,
    target                => "heartbeat_${::hostname}.cfg",
    params                => "!check_heartbeat_link",
    tag                   => "nagios_check_heartbeat_${heartbeat::nagios_hostname}",
  }

}
