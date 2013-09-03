# == Defined type: nginx::upstream_conf
#
# This defined type takes a hash of hashes and turns it into a config file.
#
# === Parameters
#
# See *nginx::upstream* class for more details.
#
# === Requires
#
# None
#
# === Examples
#
# See *nginx::upstream* class for more details.
#
# === Authors
#
# - Vaidas Jablonskis <jablonskis@gmail.com>
#
define nginx::upstream_conf(
  $server                  = undef,
  $ip_hash                 = false,
  $keepalive               = undef,
  $least_conn              = false,
  $check                   = undef,
  $check_http_send         = undef,
  $check_http_expect_alive = undef,
) {

  $conf_template = 'upstream_conf.erb'

  if $server == undef {
    fail('At least one backend server must be specified.')
  }

  file { "${nginx::vhost_dir}/${title}_upstream.conf":
    ensure  => 'file',
    mode    => '0644',
    owner   => 'root',
    group   => $nginx::user,
    content => template("${module_name}/${conf_template}"),
    notify  => Service[$nginx::service_name],
  }
}
