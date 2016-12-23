. ./common.sh

PKGNAME=bro-plugin-myricom

rm -rf "${SRC_ROOT}"/"${PKGNAME}" 2>&1 > /dev/null
rm -rf "${TMP_ROOT}" 2>&1 > /dev/null
mkdir -p "${TMP_ROOT}"/opt/bro/lib/bro/plugins 2>&1 > /dev/null

cd "${BUILD_PATH}" && git clone --recursive https://github.com/bro/bro-plugins.git "${SRC_ROOT}"/"${PKGNAME}"
cd "${SRC_ROOT}"/"${PKGNAME}"/myricom && sed -i -s 's:mkdir\ \-p\ \$installroot::' configure && ./configure --with-myricom=/opt/snf --bro-dist=/home/mpurzynski/src/bro --install-root=/opt/bro/lib/bro/plugins || exit 1
#cp ~/Myricom.cc "${SRC_ROOT}"/"${PKGNAME}"/myricom/src/Myricom.cc
make || exit 1
make install DESTDIR="${TMP_ROOT}" || exit 1

rm "${PKGNAME}"-*.x86_64.deb >/dev/null 2>&1
cd ~/

fpm -s dir -t deb -a native -v 1.0-`date +"%Y%m%d%H%M%S"` -n bro-plugin-myricom --provides bro-plugin-myricom --deb-user bro --deb-group bro -C "${TMP_ROOT}" opt/bro/lib/bro/plugins/Bro_Myricom || exit 1
