#!/bin/bash /usr/bin/msys2-shell

set -x

ls
pwd
REPO_PATH=`pwd`

PACKAGES_ROOT=${HOME}/MSYS2-packages
if ! test -d ${PACKAGES_ROOT}
then
    mkdir ${PACKAGES_ROOT}
fi

PACKAGE=xz
PKGBUILD_DIR=${PACKAGE}-git
if test -d ${PACKAGES_ROOT}/${PKGBUILD_DIR}
then
    rm -rf ${PACKAGES_ROOT}/${PKGBUILD_DIR}
fi

svn co https://github.com/Alexpux/MSYS2-packages/trunk/${PKGBUILD_DIR} ${PACKAGES_ROOT}/${PKGBUILD_DIR}

# Working around wine bug which causes msys2 git fail to clone remote repo
cd ${PACKAGES_ROOT}/${PKGBUILD_DIR}
mkdir src
pushd src
cp -r ${REPO_PATH} ${PACKAGE}
cp -v ../* . || echo skip directory
popd

makepkg -s -f --noconfirm --skippgpcheck --noextract ${NOCHECK} || echo install dependency
# Emulate prepare(), which won't be called with --noextract
(export srcdir=$(realpath src); . PKGBUILD; prepare)

makepkg -s -f --noconfirm --skippgpcheck --noextract ${NOCHECK}
