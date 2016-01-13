#!/bin/bash
# 1: build path
# 2: branch
# 3: Version
# 4: sites url

echo "Starting Build";
echo "Build path: $1";
echo "Branch: $2";
echo "Version: $3";
echo "Sites: $4"


cd $1;
rm -rf site
rm -rf sites
rm -rf generated
mkdir generated
git clone $4 sites

cd sites
communities=(*);
cd ..

for i in "${communities[@]}"
do
   :
   echo "Build: $i";
   rm -rf site/
   mv sites/$i site/
   rm -rf output/
   export GLUON_TARGET=ar71xx-generic
   export GLUON_RELEASE=$3-$2-$i
   export GLUON_BRANCH=$2
   make -j4
   mkdir generated/$i
   mv output/images/* generated/$i
   echo "Build finished";
done

echo "READY";
