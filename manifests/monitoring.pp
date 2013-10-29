class heartbeat::monitoring {

  nrpe::check { 'heartbeat':
    contrib => true,
  }

  @@nagios::check { "heartbeat-${::hostname}":
    host                  => $hostname,
    checkname             => 'check_nrpe_1arg',
    service_description   => "Heartbeat",
    notifications_enabled => 0,
    target                => "heartbeat_${::hostname}",
    params                => "!check_heartbeat",
    tag                   => "nagios_check_heartbeat_${heartbeat::nagios_hostname}",
  }

}
