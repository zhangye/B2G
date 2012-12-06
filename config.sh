#!/bin/bash

#REPO=`which repo`
REPO=./repo

repo_sync() {
	if [ "$GITREPO" = "$GIT_TEMP_REPO" ]; then
		BRANCH="master"
	else
		BRANCH=$1
	fi
	rm -rf .repo/manifest* &&
	$REPO init -u $GITREPO -b $BRANCH &&
	$REPO sync
	ret=$?
	if [ "$GITREPO" = "$GIT_TEMP_REPO" ]; then
		rm -rf $GIT_TEMP_REPO
	fi
	if [ $ret -ne 0 ]; then
		echo Repo sync failed
		exit -1
	fi
}

case `uname` in
"Darwin")
	CORE_COUNT=`system_profiler SPHardwareDataType | grep "Cores:" | sed -e 's/[ a-zA-Z:]*\([0-9]*\)/\1/'`
	;;
"Linux")
	CORE_COUNT=`grep processor /proc/cpuinfo | wc -l`
	;;
*)
	echo Unsupported platform: `uname`
	exit -1
esac

#GITREPO=${GITREPO:-"git://github.com/mozilla-b2g/b2g-manifest"}
#BRANCH=${BRANCH:-master}
GITREPO="gitb2g@shandroid01.spreadtrum.com:b2g/b2g-manifest"
	
GIT_TEMP_REPO="tmp_manifest_repo"
if [ -n "$2" ]; then
	GITREPO=$GIT_TEMP_REPO
	GITBRANCH="master"
	rm -rf $GITREPO &&
	git init $GITREPO &&
	cp $2 $GITREPO/$1.xml &&
	cd $GITREPO &&
	git add $1.xml &&
	git commit -m "manifest" &&
	cd ..
fi

echo MAKE_FLAGS=-j$((CORE_COUNT + 2)) > .tmp-config
echo GECKO_OBJDIR=$PWD/objdir-gecko >> .tmp-config
echo DEVICE_NAME=$1 >> .tmp-config

case "$1" in
"sp8810eabase")
	echo DEVICE=sp8810ea >> .tmp-config &&
	echo LUNCH=sp8810eabase-eng >> .tmp-config &&
	repo_sync nightly4.0.3_vlx_3.0_b2g
	;;

"sp8810eaplus")
	echo DEVICE=sp8810ea >> .tmp-config &&
	echo LUNCH=sp8810eaplus-eng >> .tmp-config &&
	repo_sync nightly4.0.3_vlx_3.0_b2g
	;;

"sp8810lebase")
	echo DEVICE=sp8810le >> .tmp-config &&
	echo LUNCH=sp8810lebase-eng >> .tmp-config &&
	repo_sync nightly4.0.3_vlx_3.0_b2g
	;;

"sp8810leplus")
	echo DEVICE=sp8810le >> .tmp-config &&
	echo LUNCH=sp8810leplus-eng >> .tmp-config &&
	repo_sync nightly4.0.3_vlx_3.0_b2g
	;;

"sp8810ebbase")
	echo DEVICE=sp8810eb >> .tmp-config &&
	echo LUNCH=sp8810ebbase-eng >> .tmp-config &&
	repo_sync nightly4.0.3_vlx_3.0_b2g
	;;

"sp8810ebplus")
	echo DEVICE=sp8810eb >> .tmp-config &&
	echo LUNCH=sp8810ebplus-eng >> .tmp-config &&
	repo_sync nightly4.0.3_vlx_3.0_b2g
	;;

"galaxy-s2")
	echo DEVICE=galaxys2 >> .tmp-config &&
	repo_sync $1
	;;

"galaxy-nexus")
	echo DEVICE=maguro >> .tmp-config &&
	repo_sync $1
	;;

"optimus-l5")
	echo DEVICE=m4 >> .tmp-config &&
	repo_sync $1
	;;

"nexus-s")
	echo DEVICE=crespo >> .tmp-config &&
	repo_sync $1
	;;

"nexus-s-4g")
	echo DEVICE=crespo4g >> .tmp-config &&
	repo_sync $1
	;;

"otoro"|"unagi")
	echo DEVICE=$1 >> .tmp-config &&
	repo_sync $1
	;;

"pandaboard")
	echo DEVICE=panda >> .tmp-config &&
	repo_sync $1
	;;

"emulator")
	echo DEVICE=generic >> .tmp-config &&
	echo LUNCH=full-eng >> .tmp-config &&
	repo_sync $1
	;;

"emulator-x86")
	echo DEVICE=generic_x86 >> .tmp-config &&
	echo LUNCH=full_x86-eng >> .tmp-config &&
	repo_sync emulator
	;;

*)
	echo Usage: $0 \(device name\)
	echo
	echo Valid devices to configure are:
	echo - sp8810eabase
	echo - sp8810eaplus
	echo - sp8810lebase
	echo - sp8810leplus
	echo - sp8810ebbase
	echo - sp8810ebplus
	echo - galaxy-s2
	echo - galaxy-nexus
	echo - nexus-s
	echo - nexus-s-4g
	echo - otoro
	echo - unagi
	echo - pandaboard
	echo - emulator
	echo - emulator-x86
	exit -1
	;;
esac

if [ $? -ne 0 ]; then
	echo Configuration failed
	exit -1
fi

mv .tmp-config .config

echo Run \|./build.sh\| to start building
