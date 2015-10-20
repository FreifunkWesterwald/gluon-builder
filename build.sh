#!/bin/bash
#
# Dieses Script ist der Einstiegspunkt für unsere Firmware
#
# Parameter:
# $1 = Buildverzeichnis: Ein Verzeichnis in das alles ausgecheckt wird und die Firmware gebaut wird.
# $2 = GLUON Version gegen die gebaut werden soll, z.B. v2015.1.2
# $3 = BUILD ID Wird vom Jenkins übergeben
set -u
set -e
builderHome=`pwd`;

echo "**********************";

echo "FIRMWARE BUILDPROZESS GESTARTET";
echo "FIRMWARE Builder in "  $builderHome  " gestartet";
echo "Buildverzeichnis ist " $1;
echo "Firmware wird für Gluon "$2" gebaut;"
echo "Build ist: " $3;

echo "**********************";
cd $1
pwd
git clone https://github.com/freifunk-gluon/gluon.git -b $2
cd gluon
pwd
git clone https://github.com/FreifunkWesterwald/site-fww.git site
make clean
make update
echo "ar71xx-generic wird gebaut:"
echo "==========================="
make -dkj 8 GLUON_BRANCH=stable GLUON_TARGET=ar71xx-generic V=s
echo "==========================="
echo "ar71xx-nand wird gebaut:"
echo "==========================="
make -dkj 8 GLUON_BRANCH=stable GLUON_TARGET=ar71xx-nand V=s
echo "==========================="
echo "mpc85xx-generic wird gebaut:"
echo "==========================="
make -dkj 8 GLUON_BRANCH=stable GLUON_TARGET=mpc85xx-generic V=s
echo "==========================="
echo "x86-generic wird gebaut:"
echo "==========================="
make -dkj 8 GLUON_BRANCH=stable GLUON_TARGET=x86-generic V=s
echo "==========================="
echo "KVM Guest  wird gebaut:"
echo "==========================="
make -dkj 8 GLUON_BRANCH=stable GLUON_TARGET=x86-kvm_guest V=s
echo "==========================="

echo "Build fertig nun Manifeste erstellen";
make manifest GLUON_BRANCH=stable
make manifest GLUON_BRANCH=beta
make manifest GLUON_BRANCH=nightly
echo "Checksummen generieren"
cd images
find "$PWD" -type d | sort | while read dir;
do
  cd "${dir}";
  ls | grep -v "*/*" | egrep gluon- | egrep -v "(*md5|*sha1|*sha2)" | sort | while read file;
  do
    echo "Creating MD5 checksum for" $file "..."
    md5sum $file > "$file.md5"
    echo "Creating SHA1 checksum for" $file "..."
    sha1sum $file > "$file.sha1"
    echo "Creating SHA2 checksum for" $file "..."
    sha512sum $file > "$file.sha2"
  done
done

echo "==========================="
echo "= FIRMWARE FERTIGGESTELLT ="
echo "==========================="
