#!/bin/bash
# TEMPLATE - Fill with data for your architecture
#
# Toolchain buildscript
# This script requires TWO command-line parameters:
# * The directory under which all tools are going to be installed
# * The number of threads for make

# Before running the script, the following packages need to be installed in your distro:
# (These are Ubuntu package names, if you don't use Ubuntu, look for equivalents)
# build-essential, automake, autoconf, m4, flex, bison, texinfo


TARGET="avr"

declare -A VERSIONS=( \
                      ['BINUTILS']="2.24" \
                      ['GMP']="6.0.0a" \
                      ['MPFR']="3.1.2" \
                      ['MPC']="1.0.2" \
                      ['GCC']="4.9.1" \
                      ['AVRLIBC']="1.8.1" \
                      ['SIMULAVR']="1.0.0" \
                      ['GDB']="7.8" \
                      ['AVRDUDE']="6.1" \
                      )

declare -A SITES=( \
                   ['BINUTILS']="http://ftp.gnu.org/gnu/binutils" \
                   ['GMP']="https://gmplib.org/download/gmp" \
                   ['MPFR']="http://www.mpfr.org/mpfr-${VERSIONS['MPFR']}" \
                   ['MPC']="http://www.multiprecision.org/mpc/download" \
                   ['GCC']="http://gnu.c3sl.ufpr.br/ftp/gcc/gcc-${VERSIONS['GCC']}" \
                   ['AVRLIBC']="http://download.savannah.gnu.org/releases/avr-libc" \
                   ['SIMULAVR']="http://download.savannah.gnu.org/releases/simulavr" \
                   ['GDB']="http://ftp.gnu.org/gnu/gdb" \
                   ['AVRDUDE']="http://download.savannah.gnu.org/releases/avrdude" \
                   )

declare -A PACKS=( \
                   ['BINUTILS']="binutils-${VERSIONS['BINUTILS']}.tar.gz" \
                   ['GMP']="gmp-${VERSIONS['GMP']}.tar.bz2" \
                   ['MPFR']="mpfr-${VERSIONS['MPFR']}.tar.gz" \
                   ['MPC']="mpc-${VERSIONS['MPC']}.tar.gz" \
                   ['GCC']="gcc-${VERSIONS['GCC']}.tar.gz" \
                   ['AVRLIBC']="avr-libc-${VERSIONS['AVRLIBC']}.tar.bz2" \
                   ['SIMULAVR']="simulavr-${VERSIONS['SIMULAVR']}.tar.gz" \
                   ['GDB']="gdb-${VERSIONS['GDB']}.tar.gz" \
                   ['AVRDUDE']="avrdude-${VERSIONS['AVRDUDE']}.tar.gz" \
                   )



### DO NOT EDIT THE BLOCK AFTER THIS LINE ###
DIR="$(cd -P "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd)"

THR_DEFAULT="$(grep -c ^processor '/proc/cpuinfo')"
THR="${1:-"${THR_DEFAULT}"}"

BUILD_HOME_DEFAULT="${DIR}/toolchains"
BUILD_HOME="$(readlink -m "${2:-"${BUILD_HOME_DEFAULT}"}")"

PACKDIR_DEFAULT="${BUILD_HOME}/packs"
PACKDIR="$(readlink -m "${3:-"${PACKDIR_DEFAULT}"}")"

BUILDDIR_DEFAULT="${BUILD_HOME}"
BUILDDIR="$(readlink -m "${4:-"${BUILDDIR_DEFAULT}"}/${TARGET}-gcc-${VERSIONS['GCC']}-build")"

PREFIX="${BUILD_HOME}/${TARGET}/gcc-${VERSIONS['GCC']}"
### DO NOT EDIT THE BLOCK ABOVE ###


OPTS=( 'BINUTILS' 'GMP' 'MPFR' 'MPC' 'GCC' 'AVRLIBC' 'GCC' 'SIMULAVR' 'GDB' 'AVRDUDE' )

BINUTILS=( \
           "--target=${TARGET}" \
           "--disable-nls" \
           "--disable-shared" \
           "--disable-threads" \
           "--with-gcc" \
           "--with-gnu-as" \
           "--with-gnu-ld" \
           "--enable-install-libbfd" \
           "--enable-install-libiberty" \
           "--disable-werror" \
         )

GMP=

MPFR=( \
       "--with-gmp=${PREFIX}" \
     )

MPC=( \
      "--with-gmp=${PREFIX}" \
      "--with-mpfr=${PREFIX}" \
    )

GCC=( \
      "--target=${TARGET}" \
      "--with-gmp=${PREFIX}/include" \
      "--with-mpfr=${PREFIX}/include" \
      "--with=mpc=${PREFIX}/include" \
      "--disable-nls" \
      "--enable-languages=c" \
      "--without-headers" \
      "--with-multilib" \
      "--disable-libssp" \
      "--disable-shared" \
      "--disable-threads" \
    )

AVRLIBC=( \
          "--host=${TARGET}" \
        )

GCC2=( \
       "--target=${TARGET}" \
       "--with-gmp=${PREFIX}/include" \
       "--with-mpfr=${PREFIX}/include" \
       "--with-mpc=${PREFIX}/include" \
       "--disable-nls" \
       "--enable-languages=c,c++" \
       "--with-multilib" \
       "--disable-libssp" \
       "--disable-shared" \
       "--disable-threads" \
     )

SIMULAVR=( \
           "--with-bfd=${PREFIX}/i686-pc-linux-gnu/avr" \
           "--with-libiberty=${PREFIX}/lib" \
           "CFLAGS=-Wno-error" \
         )

GDB=( \
      "--target=${TARGET}" \
      "--with-gmp=${PREFIX}" \
      "--with-mpfr=${PREFIX}" \
      "--disable-nls" \
      "--disable-libssp" \
      "--disable-werror" \
    )

AVRDUDE=( \
          "--target=${TARGET}" \
        )




#### After defining all necessary variables, source the generic part now ####
source "${DIR}/common.sh"
