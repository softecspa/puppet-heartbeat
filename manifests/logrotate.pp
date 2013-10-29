class heartbeat::logrotate {

  logrotate::file {'heartbeat':
    log           => "${heartbeat::log_dir}/ha.log ${heartbeat::log_dir}/ha.debug",
    interval      => 'daily',
    rotation      => '30',
    archive       => true,
    olddir        => "${heartbeat::log_dir}/archives",
    olddir_owner  => 'root',
    olddir_group  => 'admin',
    olddir_mode   => '775',
    create        => '644 hacluster haclient',
    options       => [ 'missingok', 'compress', 'notifempty' ],
  }
}

