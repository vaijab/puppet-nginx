# == Defined type: nginx::vhost_conf
#
# This defined type takes a hash of hashes and turns it into a config file.
#
# === Parameters
#
# See README.md.
#
# === Requires
#
# None
#
# === Examples
#
# See README.md.
#
# === Authors
#
# - Vaidas Jablonskis <jablonskis@gmail.com>
#
define nginx::vhost_conf(
    $server_name         = [$::fqdn],
    $listen              = ['80',],
    $charset             = 'off',
    $access_log          = "/var/log/nginx/${title}_access.log main",
    $error_log           = "/var/log/nginx/${title}_error.log warn",
    $index               = 'index.html',
    $include             = undef,
    $autoindex           = 'off',
    $root                = undef,
    $return              = undef,
    $keepalive_timeout   = '60s',
    $gzip                = 'on',
    $ssl_certificate     = undef,
    $ssl_certificate_key = undef,
    $ssl_ciphers         = 'ALL:!kEDH!ADH:RC4+RSA:+HIGH:+MEDIUM:+SSLv2:+EXP',
    $locations           = undef,
  ) {

  $conf_template = 'vhost_conf.erb'

  file { "${nginx::vhost_dir}/${title}.conf":
    ensure  => 'file',
    mode    => '0640',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/${conf_template}"),
    notify  => Service[$nginx::service_name],
  }
}
