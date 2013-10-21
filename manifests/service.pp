class heartbeat::service {

  service {$heartbeat::params::service_name :
    ensure      => $heartbeat::service_ensure,
    enable      => $heartbeat::service_enable,
    hasstatus   => true,
    hasrestart  => true,
  }

}
