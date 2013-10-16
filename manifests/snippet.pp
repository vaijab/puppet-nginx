# == Class: nginx::snippet
#
# See README.md.
#
# === Authors
#
# - Vaidas Jablonskis <jablonskis@gmail.com>
#
class nginx::snippet inherits nginx {
  if $::nginx::snippet != 'undef' {
    create_resources(nginx::snippet_conf,
      hiera_hash('nginx::snippet', undef)
    )
  }
}
