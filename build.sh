#!/bin/bash
#
# Dieses Script ist der Einstiegspunkt für unsere Firmware
#
# Parameter:
# $1 = Buildverzeichnis: Ein Verzeichnis in das alles ausgecheckt wird und die Firmware gebaut wird.
# $2 = GLUON Version gegen die gebaut werden soll, z.B. v2015.1.2
# $3 = BUILD ID Wird vom Jenkins übergeben
# $4 = BRANCH
set -u
set -e
builderHome=`pwd`;

echo "**********************";

echo "FIRMWARE BUILDPROZESS GESTARTET";
echo "FIRMWARE Builder in "  $builderHome  " gestartet";
echo "Buildverzeichnis ist " $1;
echo "Firmware wird für Gluon "$2" gebaut;"
echo "Build ist: " $3;
echo "Branch : " $4;
export GLUON_BRANCH=$4
export GLUON_RELEASE=build_$3;
echo "**********************";
cd $1
pwd
if [ -d gluon/ ] ; then
  echo "verzeichnis vorhanden"
  cd gluon
else
  git clone https://github.com/FreifunkWesterwald/gluon.git -b $2
  cd gluon
fi

if [ -d site/ ] ; then
  echo "site vorhanden"
  cd site
  pwd
  #git pull origin master
  cd ..
else
  git clone https://github.com/FreifunkWesterwald/site-ffww.git site
fi

make update
echo "ar71xx-generic wird gebaut:"
echo "==========================="
export GLUON_TARGET=ar71xx-generic
make -j2 V=s |& tee logfile
echo "==========================="
echo "ar71xx-nand wird gebaut:"
echo "==========================="
export GLUON_TARGET=ar71xx-nand
make -j2 V=s |& tee logfile
echo "==========================="
echo "mpc85xx-generic wird gebaut:"
echo "==========================="
export GLUON_TARGET=mpc85xx-generic
make -j2 V=s |& tee logfile
echo "==========================="
echo "x86-generic wird gebaut:"
echo "==========================="
export GLUON_TARGET=x86-generic
make -j2 V=s |& tee logfile
echo "==========================="
echo "KVM Guest  wird gebaut:"
echo "==========================="
export GLUON_TARGET=x86-kvm_guest
make -j2 V=s |& tee logfile
echo "==========================="

echo "Build fertig nun Manifest erstellen";
make manifest
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
