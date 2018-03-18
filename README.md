# bashing

__bashing__ is a small tool that let's you create single-file [Bash](http://www.gnu.org/software/bash/)
tools in a multi-file way.

Current stable Version: __0.2.2__

## Setup

### Dependencies

bashing needs the GNU variant of `sed` to function properly. If you're on MacOS
you can use e.g. Homebrew to install the package `gnu-sed`.

### Installation

```bash
mkdir -p ~/.bin
curl -ko ~/.bin/bashing https://raw.github.com/xsc/bashing/stable/bin/bashing
chmod +x ~/.bin/bashing
```

Make sure `~/.bin` is on your `$PATH`, e.g. by adding `export PATH="$PATH:~/.bin"` to your
`.bashrc`.

## Usage

Have a look at the [wiki](https://github.com/xsc/bashing/wiki) and the
[Quickstart Tutorial](https://github.com/xsc/bashing/wiki/Quickstart-Tutorial). And if you want to examine
a full-fledged Bashing project, why not [Bashing itself](https://github.com/xsc/bashing/tree/master/src)?

```bash
$ bashing new greet
Initializing ./greet ...
Successfully initialized './greet'.
$ cd greet

$ bashing new.task hi
Created Task 'hi'
$ bashing run hi
Hello from Task 'hi'
$ bashing uberbash
Creating /git/public/shell/greet/target/greet-0.1.0-SNAPSHOT.sh ...
Uberbash created successfully.

$ ./target/greet-0.1.0-SNAPSHOT.sh
Usage: ./target/greet-0.1.0-SNAPSHOT.sh <command> [<parameters> ...]

    hello    :  (no help available)
    help     :  display this help message
    hi       :  (no help available)
    version  :  display version

$ ./target/greet-0.1.0-SNAPSHOT.sh hi
Hello from Task 'hi'

$ ./target/greet-0.1.0-SNAPSHOT.sh version
greet 0.1.0-SNAPSHOT (bash 4.2.25(1)-release)

$ bashing install
Creating /git/public/shell/greet/target/greet-0.1.0-SNAPSHOT.sh ...
Uberbash created successfully.
Deploying to /home/yannick/.bin/greet ...
Deployed successfully.

$ greet version
greet 0.1.0-SNAPSHOT (bash 4.2.25(1)-release)
```

## Bashing Bashing

To build bashing, check out this repository and run:

```
$ ./bin/bashing uberbash
Creating /git/public/bashing/target/bashing-0.1.0-SNAPSHOT.sh ...
Uberbash created successfully.
```

This will create a standalone bashing script using bashing itself!

## License

Copyright &copy; 2013-2015 Yannick Scherer

Bashing is distributed under the MIT License.
