#!/bin/bash
#
# Dieses Script ist der Einstiegspunkt für unsere Firmware
#
# Parameter:
# $2 Community z.B. Westerwald
# $3 Netz z.b. Alt Neu
# $4 Branch [stable | beta | experimental]
# $5 build verzeichnis z.B. /home/gluon/build
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
   verzeichnis=`dialog --inputbox "Wo soll die Firmware gebaut werden" 0 0 "/home/gluon/build" \
 3>&1 1>&2 2>&3`
   targets=`dialog --checklist "Welche targets sollen gebaut werden? Jedes Target verbaucht 10 GB Platz!" 0 0 12 \
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

else

  community = $2
  netz = $3
  branch = $4
  verzeichnis = $5
fi


mkdir -p $verzeichnis
git clone https://github.com/FreifunkWesterwald/gluon.git
cd gluon/
if [ community == 'Westerwald' ]
  then
    git clone https://github.com/FreifunkWesterwald/site-ffww.git site
elif [[ community == 'Altenkirchen' ]];
  then
    git clone https://github.com/FreifunkWesterwald/site-ffak.git site
fi

cd ..
make update

git clone https://github.com/FreifunkWesterwald/site-
