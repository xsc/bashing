# bashing

__bashing__ is a small tool that let's you create single-file Bash tools in a multi-file
way.

Current stable Version: __0.1.2__

## Installation

```bash
mkdir -p ~/.bin 
curl -fkLo ~/.bin/bashing https://raw.github.com/xsc/bashing/stable/bin/bashing.sh
chmod +x ~/.bin/bashing
```

Make sure `~/.bin` is on your `$PATH`, e.g. by adding `export PATH="$PATH:~/.bin"` to your
`.bashrc`.

## Bashing Bashing

To build bashing, check out this repository and run:

```
$ ./bin/bashing.sh uberbash
Creating /git/public/bashing/target/bashing-0.1.0-SNAPSHOT.sh ...
Uberbash created successfully.
```

This will create a standalone bashing script using ... wait for it ... bashing itself!

## License 

Bashing is distributed under the MIT License.
