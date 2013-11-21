class heartbeat::service {

  service {$heartbeat::params::service_name :
    ensure      => $heartbeat::service_ensure,
    enable      => $heartbeat::service_enable,
    hasstatus   => true,
    hasrestart  => true,
  }

  exec {"${heartbeat::params::service_name} reload":
    command     => "/etc/init.d/${heartbeat::params::service_name} reload",
    refreshonly => true,
    subscribe   => Concat_build['ha.cf']
  }

}
