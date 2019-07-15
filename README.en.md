rubian
======

Rubian is a command-line tool which allows you to work with multiple Ruby versions. It enables system-widely installing
and managing different Ruby versions, and switching between them.

Features:

- No magic. Rubian follows Unix tradition
- No extra dependency
- No leftovers
- Available for only Debian and Debian-based distributions
- Comes with [`jemalloc`](http://jemalloc.net) support
- Supports only Matz's Ruby Interpreter (MRI)

Anti-features:

- Not available for project-specific and user-based environments

Installation
------------

Make sure that you have required packages.

- `curl`

```sh
curl -fsSL https://raw.githubusercontent.com/omu/rubian/master/rubian >/usr/local/bin/rubian
chmod +x /usr/local/bin/rubian
```

You can also easily install Rubian using [`scripts`](https://github.com/omu/omu/blob/master/bin/scripts) which is
our another helper.

```sh
scripts _/rubian
```

Usage
-----

```sh
rubian COMMAND [ARGS...]
```

Run `rubian help` to show all commands.

### Install Ruby

```sh
rubian install [OPTIONS...] VERSION...
```

`VERSION` parameter can be one of the following values:

- Full version information

  ```sh
  rubian install 2.6.1 # Installs Ruby with the version of 2.6.1
  ```

- Major version number

  ```sh
  rubian install 2.5 # Installs up-to-date Ruby with the version numbered as 2.5.x
  ```

- `latest` means up-to-date Ruby version

  ```sh
  rubian install latest # Installs Ruby with the up-to-date version
  ```

  It can also be used for updating the current Ruby.

- Multiple arguments

  ```sh
  rubian install latest 2.5.1 # Installs both `2.5.1` and `latest` Ruby versions and sets the version `2.5.1` as default
  ```

### Uninstall Ruby

```sh
rubian uninstall VERSION...
```

### Show status

Show installed Ruby versions and the currently used Ruby version:

```sh
rubian status
```

### Change version

Change your system-wide Ruby version:

```sh
rubian switch VERSION
```

### Re-link

Symlinks can be broken for many reasons. Re-link to fix it:

```sh
rubian relink
```

FAQ
---

- Where does Rubian come from?

  Ruby :heart: Debian → Rubian

Licence
-------

Rubian Copyright (C) 2019 [Alaturka Authors](https://github.com/alaturka).

[![CircleCI](https://circleci.com/gh/omu/rubian.svg)](https://circleci.com/gh/omu/rubian)
