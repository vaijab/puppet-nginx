# == Defined type: nginx::snippet_conf
#
# This defined type takes a hash of hashes and turns it into a snippet file.
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
define nginx::snippet_conf(
  $conf            = undef,
  $filename_prefix = $title,
) {

  if $conf == undef {
    fail("Module ${module_name} requires conf specified.")
  }

  # Set default file path and name
  $snippet_file = "${nginx::snippet_path}/${filename_prefix}.conf"

  file { $snippet_file:
    ensure  => file,
    mode    => '0644',
    content => $conf,
    before  => Class[nginx::vhost],
    notify  => Service[$nginx::service_name],
  }
}
