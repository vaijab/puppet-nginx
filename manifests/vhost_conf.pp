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
    $server_name                    = [$::fqdn],
    $listen                         = ['80',],
    $charset                        = 'off',
    $access_log                     = "/var/log/nginx/${title}_access.log main",
    $error_log                      = "/var/log/nginx/${title}_error.log warn",
    $index                          = 'index.html',
    $include                        = undef,
    $autoindex                      = 'off',
    $root                           = undef,
    $return                         = undef,
    $keepalive_timeout              = '60s',
    $proxy_intercept_errors         = 'off',
    $gzip                           = 'on',
    $proxy_headers_hash_bucket_size = 128,
    $ssl_certificate                = undef,
    $ssl_certificate_key            = undef,
    $ssl_ciphers                    = 'HIGH:!aNULL:!MD5',
    $locations                      = undef,
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
