# bashing

__bashing__ is a small tool that let's you create single-file Bash tools in a multi-file
way.

## Installation

```
mkdir -p ~/.bin 
curl -fkLo ~/.bin/bashing https://raw.github.com/xsc/bashing/stable/bin/bashing.sh
chmod +x ~/.bin/bashing
```

Make sure `~/.bin` is on your `$PATH`, e.g. by adding `export PATH="$PATH:~/.bin"` to your
`.bashrc`.

## Example

We will create a simple project that greets people in different ways:

```
$ greetings hello you
Hello, you!

$ greetings welcome dude
Welcome, dude!
```

Bashing will create the project structure for you with `init`:

```
$ bashing init greetings
Initializing .greetings/ ...
Successfully initialized './greetings'.
$ cd greetings
```

The directory will have the following contents:

- `bashing.project`: the project file
- `src`
  - `cli`: all our tasks (e.g. `hey`, `welcome`, etc... belong here)
     - `hello.sh`
  - `lib`: all functionality we rely on belongs here

You can immediately run the script "hello.sh" using:

```
$ bashing run hello
Hello World!
```

And you can create a standalone script with the following command:

```
$ bashing uberbash
Creating /git/edu/greetings/target/greetings-0.1.0-SNAPSHOT.sh ...
Uberbash created successfully.
$ ./target/greetings-0.1.0-SNAPSHOT.sh version
greetings 0.1.0-SNAPSHOT (bash 4.2.25(1)-release)
$ ./target/greetings-0.1.0-SNAPSHOT.sh 
Usage: ./target/greetings-0.1.0-SNAPSHOT.sh <command> [<parameters> ...]

    hello  :  (no help available)

$ ./target/greetings-0.1.0-SNAPSHOT.sh hello
Hello World!
```

As you can see, bashing creates a help message automatically. (Custom help
messages for tasks are not supported yet, thus the `(no help available)`).
The file `src/cli/hello.sh` should look like this (without unnecessary comments):

```bash
#!/bin/bash

echo "Hello World!"
```

Let's extend that to greet whatever is given as the first parameter:

```bash
#!/bin/bash

echo "Hello, $1!"
```

Run it:

```
$ bashing run hello you
Hello, you!
```

## Bashing Bashing

To build bashing, check out this repository and run:

```
$ ./bin/bashing.dev uberbash
Creating /git/public/bashing/target/bashing-0.1.0-SNAPSHOT.sh ...
Uberbash created successfully.
```

This will create a standalone bashing script using ... wait for it ... bashing itself!

## License 

Bashing is distributed under the MIT License.
