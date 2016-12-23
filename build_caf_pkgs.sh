. ./common.sh

PKGNAME=libcaf

rm -rf "${SRC_ROOT}"/"${PKGNAME}" 2>&1 > /dev/null
rm -rf "${TMP_ROOT}" 2>&1 > /dev/null
mkdir -p "${TMP_ROOT}" 2>&1 > /dev/null

cd "${BUILD_PATH}" && git clone https://github.com/actor-framework/actor-framework.git "${SRC_ROOT}"/"${PKGNAME}"
cd "${SRC_ROOT}"/"${PKGNAME}" && ./configure --prefix=/opt/libcaf || exit 1
make || exit 1
make install DESTDIR="${TMP_ROOT}" || exit 1

rm "${PKGNAME}"-*.x86_64.deb >/dev/null 2>&1
cd ~/

fpm -s dir -t deb -a native -v 1.0-`date +"%Y%m%d%H%M%S"` -n libcaf --provides libcaf --deb-user root --deb-group root -C "${TMP_ROOT}" opt/libcaf || exit 1
