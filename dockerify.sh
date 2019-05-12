#!/usr/bin/env bash
SRC=$1
TAG=$2
BINARYNAME=$3
OUTDIR=out
BINDIR=$OUTDIR/x86_64-unknown-linux-musl/release

pushd $SRC
docker run --rm -it -v "$(pwd)":/home/rust/src ekidd/rust-musl-builder cargo build -v --release --target-dir /home/rust/src/$OUTDIR &&
popd

DOCKER_FILE="
FROM scratch\n
\n
COPY $BINDIR/\* /usr/bin/\n
\n
CMD [\"/usr/bin/$BINARYNAME\"]\n
"

echo -e $DOCKER_FILE
echo -e $DOCKER_FILE > Dockerfile

docker build -t $TAG .
