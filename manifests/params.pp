class heartbeat::params {
  $package_name     = 'heartbeat'
  $crm_package_name = 'pacemaker'
  $config_dir       = '/etc/ha.d/'
  $config_file      = "${config_dir}ha.cf"
  $service_name     = 'heartbeat'
  $authkey_file     = "${config_dir}authkeys"
  $resources_file   = "${config_dir}haresources"
}
