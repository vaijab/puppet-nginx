nginx
=====

This module installs nginx and allows to manage its configuration. It
supports multiple vhost and upstream configurations as well as caching.

This module will test nginx config before reloading nginx service just
to prevent from applying incorrect config.

## Classes
* [nginx](#nginx)
* [nginx::upstream](#nginxupstream)
* [nginx::vhost](#nginxvhost)
* [nginx::snippet](#nginxsnippet)

### nginx
This class installs nginx and sets up default nginx.conf file.

#### Parameters
* `package` - Used to specify what version of the package should be used.
Valid values: `installed`, `absent` or specific package version. Default:
`installed`. Note: Puppet cannot downgrade packages.

* `service` - Determines the state of the service. Valid values: `running` or
`stopped`. Default: `running`.

* `onboot` - Whether to enable to disable the service on boot. Valid values:
`true` or `false`. Default: `true` - enabled.

* `worker_processes` - How many worker processes nginx should use. Default `$::processorcount`.

* `access_log` - Global access log. Default: `/var/log/nginx/access.log main`.

* `error_log` - Global error lo. Default: `/var/log/nginx/error.log main`.

* `index` - Space separated list of index files. Default: `index.html`.

* `worker_connections` - Maximum connections to handle at once per worker process.
Default: `1024`.

* `worker_rlimit_nofile` - Changes the limit on the maximum number of open files
(RLIMIT_NOFILE) for worker processes. Used to increase the limit without restarting
the main process. Default: `1024`.

* `reset_timedout_connection` - Enables or disables resetting timed out connections to free up
resources consumed by a connection in `FIN_WAIT1` state. Default: `on`.

* `keepalive_timeout` - Keep alive timeout in seconds. Default: `65`.

* `gzip` - Whether to enable compression. Default: `on`. Valid values: `on`
or `off`.

* `include` - A list of other configuration files to include. Default: `undef`.

* `cache_dirs` - A list of directories which are to be created for `proxy_cache_path`
or `fastcgi_cache_path` parameters. Default: `/var/cache/nginx`. Please note that
Puppet will not create directories recursively.

* `proxy_cache_path` - A list of valid `proxy_cache_path` parameters. See nginx
docs. Default: `undef`.

* `fastcgi_cache_path` - A list of valid `fastcgi_cache_path` parameters. See nginx
docs. Default: `undef`.

* `server_tokens` - Whether to display nginx version or not. Default: `off`.


#### Examples
    ---
    classes:
      - 'nginx'
    
    nginx::gzip: off
    nginx::include:
      - '/tmp/my_custom_config.conf'
    
    nginx::cache_dirs:
      - '/srv/nginx_cache'
      - '/srv/nginx_cache/myapp'

### nginx::upstream

This class configures nginx upstream config blocks using `nginx::upstream_conf`
defined type.

#### Parameters

* `server` - A list of upstream servers. If this parameter is not set then the
config will fail. It is a required parameter. Default: `undef`.

* `ip_hash` - Whether to use load balancing based on client IP hash. Valid values:
`true` or `false`. Default: `false`.

* `keepalive` - Sets the maximum number of idle keepalive connections to upstream
servers that are retained in the cache per one worker process. Default: `undef`.

* `least_conn` - Load balancing method where a request is passed to the server
with the least number of active connections, taking into account weights of servers.
Default: `false`.

The following parameters will only be available if you have `nginx_http_upstream_check_module`
(https://github.com/yaoweibin/nginx_upstream_check_module) compiled in. See the URL for the
details of the below parameters.

* `check` - Add the health check for the upstream servers. Default: `undef`.

* `check_http_send` - What http request to send. Default: `undef`.

* `check_http_expect_alive` - These status codes indicate the upstream server's http
response is OK, the backend is alive.


#### Examples
    ---
    classes:
      - nginx::upstream
    
    nginx::upstream:
      'my_app_backend':
        ip_hash: true
        least_conn: false
        server:
          - '192.168.0.1:8080 weight=3'
          - '192.168.0.2:8080 weight=1'
          - '192.168.0.3:8080 down'
    
        check: 'interval=3000 rise=2 fall=5 timeout=1000'
        check_http_send: '"GET / HTTP/1.0\r\n\r\n"'


### nginx::vhost

This class configures nginx vhost config block using `nginx::vhost_conf` defined
type.


#### Parameters
* `server_name` - A list of server names. Default: `$::fqdn`.

* `listen` - A list of ports to listen on. Default: `80`.

* `charset` - Default charset for this server. Default: `off`.

* `access_log` - Access log. Default: `/var/log/nginx/<hash name>_access.log main`.

* `error_log` - Error log. Default: `/var/log/nginx/<hash name>_error.log warn`.

* `index` - Space separated list of index files. Default: `undef`.

* `include` - Nginx include directive. Usually used to include additional
configuration files. Default: `undef`.

* `autoindex` - Enables or disables the automatic directory listing. Default: `off`.

* `root` - vhost root location. Default: `undef`.

* `return` - Return code parameter. Can return a code and some URL etc. Default: `undef`

* `keepalive_timeout` - Keep-alive timeout. Default: `60s`.

* `proxy_intercept_errors` - Determines whether proxied responses with codes greater
than or equal to 300 should be passed to a client or be redirected to nginx for processing
with the error_page directive. Default: `off`.

* `gzip` - Whether to turn gzip on. Default: `on`.

* `proxy_headers_hash_bucket_size` - Sets the bucket size for hash tables used
  by the proxy_hide_header and proxy_set_header directives. Default: `128`.

* `ssl_certificate` - SSL/TLS certificate file location. Default: `undef`.

* `ssl_certificate_key` - SSL/TLS certificate key file location. Default: `undef`.

* `ssl_ciphers` - What SSL/TLS ciphers to use.
Default: `HIGH:!aNULL:!MD5`.

* `ssl_protocols` - Enables the specified protocols. The TLSv1.1 and TLSv1.2 parameters
work only when the OpenSSL library of version 1.0.1 or higher is used.
Default: `TLSv1 TLSv1.1 TLSv1.2`.

* `ssl_client_certificate` - Specifies a file with trusted CA certificates in the PEM format used to verify client certificates. Default: `undef`

* `ssl_verify_client` - Enables verification of client certificates. Default: `off`

* `ssl_verify_depth` - Sets the verification depth in the client certificates chain. Default: `1`

* `locations` - This parameter takes an array of hashes. The `name` parameter is what
defines an actual location, the rest of parameters of the hash can be anything that nginx
supports within a location config block. See examples for more details. Default: `undef`.

#### Examples
    ---
    classes:
      - nginx::vhost
    
    # this example shows a vhost configuration for ssl and reverse proxying
    nginx::vhost:
      'www.example.com':
        listen: ['80']
        server_name: ['*.example.com']
      'www.example.com_ssl':
        listen: ['443 ssl']
        server_name: ['*.example.com']
        ssl_certificate: '/etc/pki/tls/certs/www.example.com-crt.pem'
        ssl_certificate_key: '/etc/pki/tls/private/www.example.com-key.pem'
        locations:
          - name: '/'
            proxy_pass: 'http://127.0.0.1/'
            proxy_set_header:
              - 'X-Real-IP $remote_addr'
              - 'X-Forwarded-For $proxy_add_x_forwarded_for'
              - 'Host $http_host'
          - name: '/foo'
            return: 404

### nginx::snippet

This class allows to configure nginx config snippets which can be then included
into other configuration parts. These snippets will be dropped in `/etc/nginx/snippet.d`
with `.conf` file extension by default.

#### Parameters
* `conf` - A block of text, which needs to be valid nginx configuration. See examples.
Default: `undef`.

* `filename_prefix` - By default it is set a hash name. But if for some reason you
want your snippet file name to be different, then use this parameter.

#### Examples
    ---
    classes:
      - nginx::snippet
    
    nginx::snippet:
      'error_code_404':
        filename_prefix: location_404
        conf: |
          location = /apache_404 {
            internal;
            add_header Content-Type text/javascript;
          }


## Authors
* Vaidas Jablonskis <jablonskis@gmail.com>

