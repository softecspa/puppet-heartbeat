class heartbeat::install {

  package {$heartbeat::params::package_name :
    ensure  => installed
  }

  if $heartbeat::crm {
    package {$heartbeat::params::crm_package_name :
      ensure => installed
    }
  }

}
