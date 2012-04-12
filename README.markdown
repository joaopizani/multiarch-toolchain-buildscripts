A VERY generic toolchain buildscript for different architectures, along with reasonable defaults
------------------------------------------------------------------------------------------------

Some weeks ago, I decided to compile the whole AVR toolchain from scratch, based on the latest stable
versions of the usual GCC gang for AVR (binutils, gcc, avr-libc, gdb, simulavr, avrdude). Well, it
wasn't really easy, so after some failed attempts at a process that can take hours, I decided to
automate the whole thing.

Being such an addict to perfection, I kept refactoring the script more an more, making it more and more
HOST and TARGET-independent, smaller and more organized.

Until the BIG surprise came: I could use the SAME script for compiling different version of the AVR toolchain,
AND - read careffuly - toolchains for DIFFERENT architectures. This is how the
multiarch-toolchain-buildscripts suite was born.

The suite is organized as a "generic" part, called build\_toolchain.sh, which is combined with a
target-specific part. For now we have target-specific parts for AVR and MIPS toolchains. However, it should be
REALLY easy to add more architectures to this list - you only need to copy build\_template\_toolchain.sh and
modify some few variables. The only reason for this repo having only AVR and MIPS definitions is that I'm
VERY lazy :)

The scripts themselves have pretty good commentary on why things are the way they are, but how do you actually
BUILD a toolchain using this suite??

Easy. If you need to build a toolchain for architecture XXX, run:

./build\_XXX\_toolchain.sh <n-threads> <toolchains-dirtree>

Where <n-threads> is the number of threads that _make_ should use when building, and <toolchain-dirtree> is
the place on your machine where all toolchains built with this suite shall live. The tools for architecture
XXX will be then under <toolchain-dirtree>/XXX


Everybody is welcome to add new architectures, modify the generic and specific parts, fork, send pull
requests, etc :)

PS: Works also on Mac OS X hosts!  (tested on Snow Leopard)
