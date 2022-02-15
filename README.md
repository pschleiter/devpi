# `devpi-server` docker image
The [`devpi-server`](https://devpi.net/docs/devpi/devpi/6.0/+d/index.html) as a Docker Image. For more details have a 
look at the well documented homepage of the Python package [devpi](https://devpi.net/docs/devpi/devpi/6.0/+d/index.html).


![logo](https://devpi.net/docs/devpi/devpi/6.0/+d/_static/logo.svg)

## How to use this image

###start a `devpi-server` instance

    $ docker run --name devpi -p 8080:80 -e DEVPISERVER_ROOT_PASSWD="verysecretpassword" -d pschleiter/devpi

The `devpi-server` is started and accessible under `localhost:8080`.
Furthermore, the root user with the given password is setup as well as the default index /root/pypi.

Next the server need to be setup properly by using the Python package [`devpi-client`](https://devpi.net/docs/devpi/devpi/6.0/+d/userman/devpi_user.html).

### ... via [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or [`docker-compose`](https://github.com/docker/compose)

Example `stack.yml` for `devpi-server`:

    version: '3.9'

    services:
        devpi:
            image: pschleiter/devpi:latest
            restart: always
            environment:
                DEVPISERVER_ROOT_PASSWORD: verysecretpassword
            ports:
                - 8080:80
            volumes:
                - pypi_data:/var/db
    volumes:
        pypi_data:

Run `docker stack deploy -c stack.yml devpi` (or `docker-compose -f stack.yml up`).

## How to customize this image

There are many ways to customize the `devpi-server`. One of the easiest is to customize the `stack.yml`file by adding
further environment variables.

### Environment Variables

The following documentation is the output of `devpi-init -h` and `devpi-server -h`.

#### setup options:

##### `DEVPISERVER_ROLE`

Options: master, replica, standalone, auto
set role of this instance. The default 'auto' sets
'standalone' by default and 'replica' if the `DEVPISERVER_MASTER_URL` option is used. To enable the replication protocol
you have to explicitly set the 'master' role. (Default: auto)

##### `DEVPISERVER_MASTER_URL`

run as a replica of the specified master server (Default: None)

##### `DEVPISERVER_SERVERDIR`

directory for server data. (Default: ~/.devpi/server)

##### `DEVPISERVER_STORAGE`

the storage backend to use. "sqlite": SQLite backend
with files on the filesystem, "sqlite_db_files":
SQLite backend with files in DB for testing only
(Default: None)

##### `DEVPISERVER_KEYFS_CACHE_SIZE`

size of keyfs cache. If your devpi-server installation
gets a lot of writes, then increasing this might
improve performance. Each entry uses 1kb of memory on
average. So by default about 10MB are used. (Default: 10000)

##### `DEVPISERVER_NO_ROOT_PYPI`

don't create root/pypi on server initialization.
(Default: False)

##### `DEVPISERVER_ROOT_PASSWD`

initial password for the root user. This option has no
effect if the user 'root' already exist. (Default: )

##### `DEVPISERVER_ROOT_PASSWD_HASH`

initial password hash for the root user. This option
has no effect if the user 'root' already exist. (Default: None)

#### logging options:

##### `DEVPISERVER_DEBUG`
run wsgi application with debug logging (Default: False)

##### `DEVPISERVER_LOGGER_CFG`
path to .json or .yaml logger configuration file.
(Default: None)

#### web serving options:

##### `DEVPISERVER_HOST`
domain/ip address to listen on. Use 
DEVPISERVER_host=0.0.0.0 if
you want to accept connections from anywhere.
(Default: localhost)

##### `DEVPISERVER_PORT`
port to listen for http requests. (Default: 3141)

##### `DEVPISERVER_LISTEN`
host:port combination to listen to for http requests.
When using * for host bind to all interfaces. Use
square brackets for ipv6 like (Default: ::1):8080. You can
specify more than one host:port combination with
multiple 
DEVPISERVER_listen arguments. (Default: None)

##### `DEVPISERVER_UNIX_SOCKET`
path to unix socket to bind to. (Default: None)

##### `DEVPISERVER_UNIX_SOCKET_PERMS`
permissions for the unix socket if used, defaults to
'600'. (Default: None)

##### `DEVPISERVER_THREADS`
number of threads to start for serving clients. (Default: 50)

##### `DEVPISERVER_TRUSTED_PROXY`
IP address of proxy we trust. See waitress
documentation. (Default: None)

##### `DEVPISERVER_TRUSTED_PROXY_COUNT`
how many proxies we trust when chained. See waitress
documentation. (Default: None)

##### `DEVPISERVER_TRUSTED_PROXY_HEADERS`
headers to trust from proxy. See waitress
documentation. (Default: None)

##### `DEVPISERVER_MAX_REQUEST_BODY_SIZE`
maximum number of bytes in request body. This controls
the max size of package that can be uploaded.
(Default: 1073741824)

##### `DEVPISERVER_OUTSIDE_URL`
the outside URL where this server will be reachable.
Set this if you proxy devpi-server through a web
server and the web server does not set or you want to
override the custom X-outside-url header. (Default: None)

##### `DEVPISERVER_ABSOLUTE_URLS`
use absolute URLs everywhere. This will become the
default at some point. (Default: False)

##### `DEVPISERVER_PROFILE_REQUESTS`
profile NUM requests and print out cumulative stats.
After print profiling is restarted. By default no
profiling is performed. (Default: 0)

#### mirroring options:

##### `DEVPISERVER_MIRROR_CACHE_EXPIRY`
(experimental) time after which projects in mirror
indexes are checked for new releases. (Default: 1800)

#### replica options:

##### `DEVPISERVER_MASTER_URL`
run as a replica of the specified master server (Default: None)

##### `DEVPISERVER_REPLICA_MAX_RETRIES`
Number of retry attempts for replica connection
failures (such as aborted connections to pypi). (Default: 0)

##### `DEVPISERVER_REPLICA_FILE_SEARCH_PATH`
path to existing files to try before downloading from
master. These could be from a previous replication
attempt or downloaded separately. Expects the
structure from inside +files. (Default: None)

##### `DEVPISERVER_HARD_LINKS`
use hard links during export, import or with

DEVPISERVER_REPLICA_FILE_SEARCH_PATH instead of copying or
downloading files. All limitations for hard links on
your OS apply. USE AT YOUR OWN RISK (Default: False)

##### `DEVPISERVER_REPLICA_CERT`
when running as a replica, use the given .pem file as
the SSL client certificate to authenticate to the
server (EXPERIMENTAL) (Default: None)

##### `DEVPISERVER_FILE_REPLICATION_THREADS`
number of threads for file download from master (Default: 5)

##### `DEVPISERVER_PROXY_TIMEOUT`
Number of seconds to wait before proxied requests from
the replica to the master time out (login, uploads
etc). (Default: 30)

#### request options:

##### `DEVPISERVER_REQUEST_TIMEOUT`
Number of seconds before request being terminated
(such as connections to pypi, etc.). (Default: 5)

##### `DEVPISERVER_OFFLINE_MODE`
(experimental) prevents connections to any upstream
server (e.g. pypi) and only serves locally cached
files through the simple index used by pip. (Default: False)

#### storage options:

##### `DEVPISERVER_SERVERDIR`
directory for server data. (Default: ~/.devpi/server)

##### `DEVPISERVER_STORAGE`
the storage backend to use. "sqlite": SQLite backend
with files on the filesystem, "sqlite_db_files":
SQLite backend with files in DB for testing only
(Default: None)

##### `DEVPISERVER_KEYFS_CACHE_SIZE`
size of keyfs cache. If your devpi-server installation
gets a lot of writes, then increasing this might
improve performance. Each entry uses 1kb of memory on
average. So by default about 10MB are used. (Default: 10000)

#### deployment options:

##### `DEVPISERVER_SECRETFILE`
file containing the server side secret used for user
validation. If not specified, a random secret is
generated on each start up. (Default: None)

##### `DEVPISERVER_ARGON2_MEMORY_COST`
Argon2 memory cost parameter for key derivation. This
is *not* for the user password hashes. There should be
no need to touch this setting, except you really know
what this is about! Replicas need to use the same
parameters as the master. (Default: 524288)

##### `DEVPISERVER_ARGON2_PARALLELISM`
Argon2 parallelism parameter for key derivation. This
is *not* for the user password hashes. There should be
no need to touch this setting, except you really know
what this is about! Replicas need to use the same
parameters as the master. (Default: 8)

##### `DEVPISERVER_ARGON2_TIME_COST`
Argon2 time cost parameter for key derivation. This is
*not* for the user password hashes. There should be no
need to touch this setting, except you really know
what this is about! Replicas need to use the same
parameters as the master. (Default: 16)

##### `DEVPISERVER_REQUESTS_ONLY`
only start as a worker which handles read/write web
requests but does not run an event processing or
replication thread. (Default: False)

#### permission options:

##### `DEVPISERVER_RESTRICT_MODIFY`
specify which users/groups may create other users and
their indices. Multiple users and groups are separated
by commas. Groups need to be prefixed with a colon
like this: ':group'. By default anonymous users can
create users and then create indices themself, but not
modify other users and their indices. The root user
can do anything. When this option is set, only the
specified users/groups can create and modify users and
indices. You have to add root explicitely if wanted.
(Default: None)

#### devpi-web theme options:

##### `DEVPISERVER_THEME`
folder with template and resource overwrites for the
web interface (Dfault: None)

#### devpi-web doczip options:

##### `DEVPISERVER_DOCUMENTATION_PATH`
path for unzipped documentation. By default the
DEVPISERVER_SERVERDIR is used. (Default: None)

#### devpi-web search indexing:

##### `DEVPISERVER_INDEXER_BACKEND`
the indexer backend to use (Default: whoosh)
