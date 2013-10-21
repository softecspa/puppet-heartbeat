define heartbeat::interface (
  interface,
  address,
  nodename,
  ha_tag,
) {

  concat_fragment {"ha.cf+002-${name}.tmp":
    content => inline_template("# interface(s) to monitor on the other node\nbcast <%= interface %>\nucast <%= interface %> <%= address %>\nudp <%= interface %>")
  }
}
