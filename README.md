# gollum-bad

Gollum config which implements Basic Auth for Destructive operations (BAD!).

It configures gollum with a before action which requires user and password if
the route requested matches any one of:

* `/edit`
* `/uploadFile`
* `/create`
* `/delete`
* `/revert`
* `/rename`

## Usage

User and password are defined in the environmnet variables `gollum_usuario` and `gollum_password` when you start the daemon, for example:

    gollum_usuario=admin gollum_password=secret gollum --config /path/to/gollum-bad

## Bugs/Features

Beware! If you name a file in the root space which matches any of the protected
routes, it will ask your credentials for reading it too.
