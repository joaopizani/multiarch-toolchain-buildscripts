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


TARGET=""

declare -A VERSIONS=( \
                      ['BINUTILS']="" \
                      ['GMP']="" \
                      ['MPFR']="" \
                      ['MPC']="" \
                      ['GCC']="" \
                      ['NEWLIB']="" \
                      ['GDB']="" \
                      )

declare -A SITES=( \
                   ['BINUTILS']="http://ftp.gnu.org/gnu/binutils" \
                   ['GMP']="https://gmplib.org/download/gmp" \
                   ['MPFR']="http://www.mpfr.org/mpfr-current" \
                   ['MPC']="http://www.multiprecision.org/mpc/download" \
                   ['GCC']="http://gnu.c3sl.ufpr.br/ftp/gcc/gcc-${VERSIONS['GCC']}" \
                   ['NEWLIB']="ftp://sources.redhat.com/pub/newlib" \
                   ['GDB']="http://ftp.gnu.org/gnu/gdb" \
                   )

declare -A PACKS=( \
                   ['BINUTILS']="binutils-${VERSIONS['BINUTILS']}.tar.gz" \
                   ['GMP']="gmp-${VERSIONS['GMP']}.tar.bz2" \
                   ['MPFR']="mpfr-${VERSIONS['MPFR']}.tar.gz" \
                   ['MPC']="mpc-${VERSIONS['MPC']}.tar.gz" \
                   ['GCC']="gcc-${VERSIONS['GCC']}.tar.gz" \
                   ['NEWLIB']="newlib-${VERSIONS['NEWLIB']}.tar.gz" \
                   ['GDB']="gdb-${VERSIONS['GDB']}.tar.gz" \
                   )


OPTS=( 'BINUTILS' 'GMP' 'MPFR' 'MPC' 'GCC' 'NEWLIB' 'GCC' 'GDB' )

BINUTILS=( "--target=${TARGET}" \
           "--disable-nls" \
           "--disable-shared" \
           "--with-gnu-as" \
           "--with-gnu-ld" \
           "--enable-install-libbfd" \
           "--disable-werror" \
           )

GMP=

MPFR=( "--with-gmp=${PREFIX}" )

MPC=( "--with-gmp=${PREFIX}" \
      "--with-mpfr=${PREFIX}" \
      )

GCC=( "--target=${TARGET}" \
      "--with-mpfr=${PREFIX}" \
      "--with=mpc=${PREFIX}" \
      "--disable-nls" \
      "--enable-languages=c" \
      "--without-headers" \
      "--with-newlib" \
      "--with-multilib" \
      "--disable-libssp" \
      "--disable-shared" \
      "--disable-threads" \
      )

NEWLIB=( "--host=${TARGET}" )

GCC2=( "--target=${TARGET}" \
       "--with-mpfr=${PREFIX}" \
       "--with-mpc=${PREFIX}" \
       "--disable-nls" \
       "--enable-languages=c,c++" \
       "--with-newlib" \
       "--with-multilib" \
       "--disable-libssp" \
       "--disable-shared" \
       "--disable-threads" \
       )

GDB=( "--target=${TARGET}" \
      "--with-gmp=${PREFIX}" \
      "--with-mpfr=${PREFIX}" \
      "--disable-nls" \
      "--disable-libssp" \
      "--disable-werror" \
    )




THR_DEFAULT="$(grep -c ^processor '/proc/cpuinfo')"
THR="${1:-"${THR_DEFAULT}"}"

BUILD_HOME_DEFAULT="${HOME}/build"
BUILD_HOME="${2:-"${BUILD_HOME_DEFAULT}"}"

PACKDIR_DEFAULT="${BUILD_HOME}/packs"
PACKDIR="${3:-"${PACKDIR_DEFAULT}"}"

BUILDDIR_DEFAULT="${BUILD_HOME}"
BUILDDIR="${4:-"${BUILDDIR_DEFAULT}"}/${TARGET}-gcc-${VERSIONS['GCC']}-build"

PREFIX="${BUILD_HOME}/${TARGET}/gcc-${VERSIONS['GCC']}"


#### After defining all necessary variables, source the generic part now ####
source "./common.sh"
