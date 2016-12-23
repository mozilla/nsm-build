. ./common.sh

PKGNAME=bro-plugin-af-packet

rm -rf "${SRC_ROOT}"/"${PKGNAME}" 2>&1 > /dev/null
rm -rf "${TMP_ROOT}" 2>&1 > /dev/null
mkdir -p "${TMP_ROOT}"/opt/bro/lib/bro/plugins 2>&1 > /dev/null

cd "${BUILD_PATH}" && git clone --recursive https://github.com/bro/bro-plugins.git "${SRC_ROOT}"/"${PKGNAME}"
cd "${SRC_ROOT}"/"${PKGNAME}"/af_packet && sed -i -s 's:mkdir\ \-p\ \$installroot::' configure && ./configure --bro-dist=/home/mpurzynski/src/bro --install-root=/opt/bro/lib/bro/plugins --with-kernel=/usr/src/kernels/`uname -r` || exit 1
make || exit 1
make install DESTDIR="${TMP_ROOT}" || exit 1

rm "${PKGNAME}"-*.x86_64.deb >/dev/null 2>&1
cd ~/

fpm -s dir -t deb -a native -v 1.0-`date +"%Y%m%d%H%M%S"` -n bro-plugin-afpacket --provides bro-plugin-afpacket --deb-user bro --deb-group bro -C "${TMP_ROOT}" opt/bro/lib/bro/plugins/Bro_AF_Packet || exit 1
