#!/usr/bin/env bash

# MIT License
#
# Copyright (c) 2019 Alexander Serebryakov
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

VERSION=0.1.0
SRC=
BINARYNAME=
TAG=
OUTDIR=out
BINDIR=$OUTDIR/x86_64-unknown-linux-musl/release
BUILD=0

function _build_image {
	if [ "$BUILD" = "1" ]; then
		docker build -t $TAG .
	fi
}

function _build_app {
	if [ ! -d $SRC ]; then
		echo "Directory doesn't exist : $SRC"
		exit 1
	fi

	pushd $SRC
	docker run --rm -it -v "$(pwd)":/home/rust/src ekidd/rust-musl-builder cargo build -v --release --target-dir /home/rust/src/$OUTDIR &&
	popd

	if [ ! -e $SRC/$BINDIR/$BINARYNAME ]; then
		echo "Binary doesn't exist : $SRC/$BINDIR/$BINARYNAME"
		exit 1
	fi

	if [ -d artifacts ]; then
		rm -rfv artifacts
	fi

	cp -RLv `realpath $SRC/$BINDIR/` artifacts
}

function _generate_dockerfile {
	DOCKER_FILE="
FROM scratch\n
COPY ./artifacts/\* /usr/bin/\n
CMD [\"/usr/bin/$BINARYNAME\"]\n"

	echo "Docker file to be created"
	echo -e $DOCKER_FILE > Dockerfile
	cat Dockerfile
}

function _print_help_and_exit {
	echo "dockerify $VERSION" >&2
	echo "" >&2
	echo "usage: $(basename $0) -s source_directory -e binary name [-b] [-t container_tag]" >&2
	echo "    -s Path to source directory" >&2
	echo "    -e Binary name to be used as CMD argument in Dockerfile" >&2
	echo "    -b Run docker build immediately" >&2
	echo "    -t Container tag (required for build)" >&2
	exit 1
}

function _print_config {
	echo "Source directory : $SRC"
	echo "Binary name directory : $BINARYNAME"
	if [ "$BUILD" != "0" ]; then
		echo "Automatic build enabled"
		echo "Docker tag is $TAG"
	fi
}

function _validate_arguments {
	if [ "$SRC" = "" ] || [ "$BINARYNAME" = "" ]; then
		_print_help_and_exit
	fi

	if [ "$BUILD" = "1" ] && [ "$TAG" = "" ]; then
		echo "Tag must be set for build"
		exit 1
	fi
}

while getopts 's:e:t:b' OPTION; do
	case "$OPTION" in
		s) SRC=`realpath $OPTARG` ;;
		e) BINARYNAME=$OPTARG ;;
		t) TAG=$OPTARG ;;
		b) BUILD=1 ;;
		?) _print_help_and_exit ;;
	esac
done

_validate_arguments
_print_config
_build_app
_generate_dockerfile
_build_image
