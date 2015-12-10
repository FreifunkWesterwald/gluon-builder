#!/bin/bash
#
# Dieses Script ist der Einstiegspunkt für unsere Firmware
#
# Parameter:
# $2 Community z.B. Westerwald
# $3 Netz z.b. Alt Neu
# $4 Branch [stable | beta | experimental]
# $5 build verzeichnis z.B. /home/gluon/build
# $6 version z.B. 0.11
# $7 Kernelanzahl

set -u
set -e
builderHome=`pwd`;

if [ $1 == 'gui' ]
  then
   # Für welche Community soll gebaut werden?
   community=`dialog --menu "Community auswählen" 0 0 0 \
   "Westerwald" "" "Altenkirchen" "" 3>&1 1>&2 2>&3`
   netz=`dialog --menu "Netz auswählen" 0 0 0 \
   "Alt" "" "Neu" "" 3>&1 1>&2 2>&3`
   branch=`dialog --menu "Branch auswählen" 0 0 0 \
   "stable" "" "beta" "" "experimental" "" 3>&1 1>&2 2>&3`
   verzeichnis=`dialog --inputbox "Wo soll die Firmware gebaut werden?" 0 0 "/home/cernota/git/gluon-builder/build" \
 3>&1 1>&2 2>&3`
   targets=`dialog --checklist "Welche targets sollen gebaut werden? Jedes Target verbraucht 10 GB Platz!" 0 0 12 \
     ar71xx-generic "" on\
     ar71xx-nand "" off\
     brcm2708-bcm2708 "" off\
     brcm2708-bcm2709 "" off\
     mpc85xx-generic "" off\
     ramips-rt305x "" off\
     x86-64 "" off\
     x86-generic "" off\
     x86-kvm_guest "" off\
     x86-xen_domu "" off\
     sunxi "" off 3>&1 1>&2 2>&3`
     version=`dialog --inputbox "Wie ist die Version der Firmware?" 0 0 "x.xx" \
   3>&1 1>&2 2>&3`
   kernelmax=`dialog --inputbox "Wie viele Kerne stehen zur Verfügung" 0 0 "4" \
 3>&1 1>&2 2>&3`
else

  community = $2
  netz = $3
  branch = $4
  verzeichnis = $5
  version = $6
  kernelmax = $7
fi


mkdir -p $verzeichnis
cd $verzeichnis
if [ ! -d gluon/ ]
  then
    git clone https://github.com/FreifunkWesterwald/gluon.git
fi
cd gluon/
make update
rm -rf site/
if [ $community == 'Westerwald' ]
  then
    echo "Westerwald wird gebaut"
    git clone https://github.com/FreifunkWesterwald/site-ffww.git site
elif [[ $community == 'Altenkirchen' ]];
  then
    echo "Altenkirchen wird gebaut"
    git clone https://github.com/FreifunkWesterwald/site-ffak.git site
fi


export GLUON_BRANCH=$branch
if [[ $branch == 'experimental' ]]; then
  export GLUON_RELEASE=$version-exp
elif [[ $branch == 'beta' ]]; then
  export GLUON_RELEASE=$version-beta
elif [[ $branch == 'stable' ]]; then
  export GLUON_RELEASE=$version-stable
fi

for i in "${targets[@]}"
do
   :
   export GLUON_TARGET=$i
   make clean
   make -j$kernelmax
done
if [[ $1 == 'gui']]
  then
    notify-send 'Fertig :)'
fi
