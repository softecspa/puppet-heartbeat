# = Define heartbeat::VIP
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
