# = Define heartbeat::vip
#
#   This define add a VIP to the heartbeat resources
#
# == Parameters
#
# [*vip*]
#   VIP address to add. If not defined <name> will be used
#
# [*netmask*]
#   Netmask of the vip in integer form
#
# [*interface*]
#   Interfaces used to manage VIP
#
# [*bcast*]
#   Broadcast address of selected VIP
#
# [*pref_node*]
#   Prefered node for the resource
#
# [*mail*]
#   Mail address used for resource switch notification. If blank no mail is sent
#
# [*source_nat*]
#   Enable source nat on VIP
#
define heartbeat::vip (
  $netmask,
  $interface,
  $bcast,
  $pref_node,
  $mail               = '',
  $vip                = '',
  $file_template      = 'heartbeat/haresources/vip.erb',
  $source_nat         = false,
) {

  if !defined(Class['heartbeat']) {
    fail ('Class[heartbeat] not exists. Please define it first')
  }

  $resource_vip = $vip ? {
    ''      => $name,
    default => $vip,
  }

  if ( $resource_vip !~ /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/ ) {
    fail('invalid vip was specifed')
  }

  if !is_integer($netmask) {
    fail('netmask must be an integer value')
  }

  if $bcast !~ /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/ {
    fail('invalid bcast address was specified')
  }

  if ( $mail != '' ) and ( $mail !~ /.+@.+\..{1,4}$/ ) {
    fail('invalid mail was specified')
  }

  concat_fragment {"haresources+002-${name}.tmp":
    content => template($file_template)
  }

}
