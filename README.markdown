A VERY generic toolchain buildscript for different architectures, along with reasonable defaults
------------------------------------------------------------------------------------------------

Some weeks ago, I decided to compile the whole AVR toolchain from scratch, based on the latest stable
versions of the usual GCC gang for AVR (binutils, gcc, avr-libc, gdb, simulavr, avrdude). Well, it
wasn't really easy, so after some failed attempts at a process that can take hours, I decided to
automate the whole thing.

Being such an addict to perfection, I kept refactoring the script more an more, making it more and more
**host** and **target-independent**, smaller and more organized.

Until the BIG surprise came: I could use the **same** script for compiling different version of the AVR toolchain,
and – read careffuly – toolchains for **different** architectures.
This is how the multiarch-toolchain-buildscripts suite was born.

The suite is organized as a "generic" part, called `common.sh`, which is combined with a target-specific part.
For now we have target-specific parts for AVR and MIPS toolchains.
However, it should be **really** easy to add more architectures to this list – you only
need to copy `build_template.sh` and modify some few variables.
The only reason for this repo having only AVR and MIPS definitions is that I'm lazy ☺

The scripts themselves have pretty good commentary on why things are the way they are,
but how do you actually build a toolchain using this suite??

Easy. If you need to build a toolchain for a certain architecture `<arch>`, then run:

```bash
./build_<arch>.sh <n-threads> <toolchains-dirtree>
```

Where `<n-threads>` is the number of threads that _make_ should use when building,
and `<toolchain-dirtree>` is the place on your machine where all toolchains built with this suite shall live.
The tools for architecture `<arch>` will be then under `<toolchain-dirtree>/<arch>`

Everybody is welcome to add new architectures, modify the generic and specific parts, fork, send pull requests, etc ☺

PS: Works also on Mac OS X hosts!  (tested on Snow Leopard)
