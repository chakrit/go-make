# GO-MAKE

A small Makefile and support scripts for conveniently working with the `go` tool and
Go language projects.

Features:

* Same commands that works anywhere, on any directory inside your `$GOPATH`
* Automatic dependencies resolution. Just type `gomake build` and it builds, no need to
  find out what things to `go get` first. Also works with `gomake test` and `gomake
  cover`.
* Cross-compile to other architecture. For example: `gomake linux-amd64`.

# SETUP

Clone this repository and adds the `gomake` script to your `$PATH` or add an alias to your
`.bashrc` or `.zshrc` file.

```sh
alias gomake="~/Documents/go-make/gomake"
```

To enable cross-compilation support, you need to build the cross-compilers first. Just
clone the [golang-crosscompile][0] project and do the following:

```sh
cd ~/Documents/go-make
source ./golang-crosscompile/crosscompile.bash
go-crosscompile-build-all
```

You only need to do this once. The supplied `Makefile` automatically source the required
functions for you afterwards.

# TARGETS

All targets must be invoked inside your `$GOPATH`.

* `gomake deps` - Install packages' dependencies.
* `gomake test-deps` - Install packages' test dependencies.

* `gomake build` - Builds the package and produce a binary.
* `gomake clean` - Cleans artifacts related with the current folder.

* `gomake test` - Runs go test.
* `gomake cover` - Runs go test with `-cover` option.

* `gomake vet` - Installs the `vet` go tool and runs it.
* `gomake fmt` - Formats all sources in the current folder.

All commands only effect the current package, you can include additional packages by
giving `gomake` a `PKG` variable. However, most of the time if your package imports its
subpackages, you should be just fine.

# CROSSCOMPILE

To cross-compile into other architecture, you need to build the cross-compiler first
(refer to SETUP). Then just use the target platform as the make target.

For example, to build for `linux/amd64` platform, type:

```sh
gomake linux-amd64
```

This will builds a binary of the package for the `linux/amd64` platform.

# LICENSE

BSD

[0]: https://github.com/davecheney/golang-crosscompile

