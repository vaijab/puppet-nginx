# == Class: nginx::vhost
#
# See README.md.
#
# === Authors
#
# - Vaidas Jablonskis <jablonskis@gmail.com>
#
class nginx::vhost inherits nginx {
  if $::nginx::vhost != 'undef' {
    create_resources(nginx::vhost_conf,
      hiera_hash('nginx::vhost', undef)
    )
  }
}
