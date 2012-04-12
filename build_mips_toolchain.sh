#!/bin/bash
# Toolchain buildscript
# This script requires TWO command-line parameters: the number of threads for make and the
# directory under which all tools are going to be installed.

# Before running the script, the following packages need to be installed in your distro:
# (These are Ubuntu package names, if you don't use Ubuntu, look for equivalents)
#
# build-essential, automake, autoconf, m4, flex, bison, texinfo

THREADS="-j $1" # DON'T CHANGE
BUILD_HOME=$2   # DON'T CHANGE


# if you want less messages from compilation in your output, use SILENT_BUILD=1
SILENT_BUILD=

# use the GCC target name for the desired architecture here, i.e, "avr", "mips-elf", etc.
TARGET=mips-elf

# You should probably use the most recent stable versions... but sometimes you need
# a bit more research...
BINUTILS_VERSION=2.22
GMP_VERSION=5.0.4
MPFR_VERSION=3.1.0
MPC_VERSION=0.9
GCC_VERSION=4.7.0
NEWLIB_VERSION=1.20.0
GDB_VERSION=7.4


# Optional editing: only if some site has changed
BINUTILS_SITE=http://ftp.gnu.org/gnu/binutils
GMP_SITE=ftp://ftp.gmplib.org/pub/gmp-$GMP_VERSION
MPFR_SITE=http://mpfr.loria.fr/mpfr-current
MPC_SITE=http://www.multiprecision.org/mpc/download
GCC_SITE=http://gnu.c3sl.ufpr.br/ftp/gcc/gcc-$GCC_VERSION
NEWLIB_SITE=ftp://sources.redhat.com/pub/newlib
GDB_SITE=http://ftp.gnu.org/gnu/gdb

#### CAREFUL EDITING FROM HERE ON ####


PREFIX=$BUILD_HOME/$TARGET/gcc-$GCC_VERSION

BINUTILS=binutils-$BINUTILS_VERSION
GMP=gmp-$GMP_VERSION
MPFR=mpfr-$MPFR_VERSION
MPC=mpc-$MPC_VERSION
GCC=gcc-$GCC_VERSION
NEWLIB=newlib-$NEWLIB_VERSION
GDB=gdb-$GDB_VERSION


PACKLITERALS=(  '$BINUTILS' '$GMP'     '$MPFR'   '$MPC'    '$GCC'    '$NEWLIB' '$GDB')
PACKEXTENSIONS=('.tar.gz'   '.tar.bz2' '.tar.gz' '.tar.gz' '.tar.gz' '.tar.gz' '.tar.gz')
TASKLITERALS='$BINUTILS $GMP $MPFR $MPC $GCC $NEWLIB $GCC $GDB' # 2 GCC tasks (pre- and post-bootstrap)

# Configure options for all packages. Change only if the "reasonable" defaults don't work
BINUTILS_OPT="--target=$TARGET --disable-nls --disable-shared --with-gnu-as --with-gnu-ld --enable-install-libbfd --enable-install-libiberty --disable-werror"
GMP_OPT=""
MPFR_OPT="--with-gmp=$PREFIX"
MPC_OPT="--with-gmp=$PREFIX --with-mpfr=$PREFIX"
GCC_OPT="--target=$TARGET --with-mpfr=$PREFIX --with-mpc=$PREFIX --disable-nls --enable-languages=c --without-headers --with-newlib --with-multilib --disable-libssp --disable-libquadmath"
NEWLIB_OPT="--host=$TARGET"
GCC_2_OPT="--target=$TARGET --with-mpfr=$PREFIX --with-mpc=$PREFIX --disable-nls --enable-languages=c,c++ --with-newlib --with-multilib --disable-libssp --disable-libquadmath"
GDB_OPT="--target=$TARGET --with-gmp=$PREFIX --with-mpfr=$PREFIX --disable-nls --disable-libssp --disable-werror"



#### After defining all necessary variables, source the generic part now ####
source ./build_toolchain.sh
