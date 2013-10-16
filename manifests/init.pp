# == Class: nginx
#
# This class installs nginx and sets main configuration parameters.
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
class nginx(
  $service                   = 'running',
  $onboot                    = true,
  $package                   = 'installed',
  $worker_processes          = $::processorcount,
  $worker_rlimit_nofile      = '1024',
  $worker_connections        = 1024,
  $reset_timedout_connection = 'on',
  $access_log                = '/var/log/nginx/access.log main',
  $error_log                 = '/var/log/nginx/error.log warn',
  $index                     = undef,
  $keepalive_timeout         = 60,
  $gzip                      = 'on',
  $include                   = undef,
  $proxy_cache_path          = undef,
  $fastcgi_cache_path        = undef,
  $cache_dirs                = [],
  $server_tokens             = 'off',
) {
  case $::osfamily {
    RedHat: {
      $package_name         = 'nginx'
      $service_name         = 'nginx'
      $vhost_dir            = '/etc/nginx/vhost.d'
      $user                 = 'nginx'
      $redundant_conf_files = [ '/etc/nginx/conf.d/default.conf',
                                '/etc/nginx/conf.d/example_ssl.conf' ]
    }
    Debian: {
      $package_name         = 'nginx-full'
      $service_name         = 'nginx'
      $vhost_dir            = '/etc/nginx/sites-enabled'
      $user                 = 'www-data'
      $redundant_conf_files = [ '/etc/nginx/sites-enabled/default' ]
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }

  $snippet_path = '/etc/nginx/snippet.d'

  $config_file   = '/etc/nginx/nginx.conf'
  $conf_template = 'nginx.conf.erb'

  package { $package_name:
    ensure => $package,
  }

  file { $config_file:
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/${conf_template}"),
    require => Package[$package_name],
  }

  file { $snippet_path:
    ensure  => directory,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package[$package_name],
    purge   => true,
    recurse => true,
  }

  file { $vhost_dir:
    ensure  => directory,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Package[$package_name],
    purge   => true,
    recurse => true,
  }

  # Create cache directories
  file { ['/var/cache/nginx', $cache_dirs]:
    ensure  => directory,
    mode    => '0750',
    owner   => $user,
    group   => $user,
    require => Package[$package_name],
  }

  # Removes nginx example config files
  file { $redundant_conf_files:
    ensure => absent,
  }

  service { $service_name:
    ensure    => $service,
    enable    => $onboot,
    start     => 'nginx -t && service nginx start',
    restart   => 'nginx -t && service nginx reload',
    hasstatus => true,
    require   => [File[$config_file],
                  File[$redundant_conf_files],
                  Package[$package_name]],
    subscribe => File[$config_file],
  }
}
