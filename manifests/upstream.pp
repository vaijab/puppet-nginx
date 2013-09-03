# == Class: nginx::upstream
#
# This class configures nginx upstream config blocks using
# <code>nginx::upstream_conf</code> defined type.
#
# === Parameters
#
# See README.md.
#
# === Requires
#
# None
#
# === Authors
#
# - Vaidas Jablonskis <jablonskis@gmail.com>
#
class nginx::upstream inherits nginx {
  if $::nginx::upstream != 'undef' {
    create_resources(nginx::upstream_conf,
      hiera_hash('nginx::upstream', undef)
    )
  }
}
