class heartbeat::configure {

  file {$heartbeat::params::config_file :
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Concat_build['ha.cf'],
  }

  concat_build{'ha.cf':
    order   => ['*.tmp'],
    target  => $heartbeat::params::config_file,
  }

  if !$heartbeat::crm {

    file {$heartbeat::params::resources_file :
      mode    => 644,
      owner   => 'root',
      group   => 'root',
      require => Concat_build['haresources'],
    }

    concat_build {'haresources':
      order   => ['*.tmp'],
      target  => $heartbeat::params::resources_file
    }

    concat_fragment {'haresources+001.tmp':
      content => '#File managed by puppet. Do not manually edit'
    }
  }

  concat_fragment{'ha.cf+001.tmp':
    content => template($heartbeat::file_template)
  }

  concat_fragment{'ha.cf+003.tmp':
    content => template($heartbeat::failback_file_template)
  }

  concat_fragment{'ha.cf+005.tmp':
    content => template($heartbeat::watchdog_file_template)
  }

  file { $heartbeat::params::authkey_file :
    content => "auth 1\n1 sha1 ${heartbeat::authkey}\n",
    owner   => "root",
    mode    => 0600,
    notify  => Exec["$heartbeat::params::service_name reload"],
  }

  @@concat_fragment {"ha.cf+004-$hostname.tmp":
    content => inline_template("node $hostname"),
    tag     => $heartbeat::ha_tag,
  }

  Heartbeat::Interface <<| (ha_tag == $heartbeat::ha_tag) and (nodename != $hostname) |>>
  Concat_fragment <<| tag == $heartbeat::ha_tag |>>

  file {$heartbeat::log_dir :
    ensure  => directory,
    mode    => '755',
    owner   => 'root',
    group   => 'root'
  }

  # permette di far bindare i servizi su ip non locali
  sysctl::conf{'bind':
    comment => 'Allow to bind services on a non local address',
    key     => 'net.ipv4.ip_nonlocal_bind',
    value   => 1
  }

  sysctl::conf{'core_uses_pid':
    comment => 'Requested from HeartBeat',
    key     => 'kernel.core_uses_pid',
    value   => 1
  }

  #load watchdog module
  if $haproxy::watchdog {
    modprobe::load {'softdog': }
  }

  file {"$heartbeat::params::scripts_dir/SourceNat":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/heartbeat/etc/SourceNat'
  }

}
