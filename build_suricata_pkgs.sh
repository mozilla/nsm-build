. ./common.sh

BOOST_VER=1_60_0
BOOT_URL=http://downloads.sourceforge.net/project/boost/boost/1.60.0/boost_"${BOOST_VER}".tar.gz

rm -rf "${SRC_ROOT}"/boost_"${BOOST_VER}" 2>&1 > /dev/null
rm -rf "${SRC_ROOT}"/boost_"${BOOST_VER}".tar.gz 2>&1 > /dev/null

wget http://downloads.sourceforge.net/project/boost/boost/1.60.0/boost_"${BOOST_VER}".tar.gz -O "${SRC_ROOT}"/boost_"${BOOST_VER}".tar.gz || exit 1
tar zxvf "${SRC_ROOT}"/boost_"${BOOST_VER}".tar.gz -C "${SRC_ROOT}" || exit 1
cd "${SRC_ROOT}"/boost_"${BOOST_VER}"
./bootstrap.sh --prefix="${BUILD_PATH}"/tmp/boost_"${BOOST_VER}"
./b2 install

PKGNAME=hyperscan

rm -rfv "${SRC_ROOT}"/"${PKGNAME}"
cd "${BUILD_PATH}" && git clone https://github.com/01org/hyperscan "${SRC_ROOT}"/"${PKGNAME}" || exit 1
cd "${SRC_ROOT}"/"${PKGNAME}"
mkdir build && cd build || exit 1

cmake -DBUILD_STATIC_AND_SHARED=1 -DBOOST_ROOT="${BUILD_PATH}"/tmp/boost_"${BOOST_VER}" -DCMAKE_INSTALL_PREFIX:PATH="${BUILD_PATH}"/"${TMP_ROOT}"/opt/hyperscan .. && make && make install
rm -rfv "${BUILD_PATH}"/tmp/boost_"${BOOST_VER}" 2>&1 > /dev/null

cd "${BUILD_PATH}"
fpm -s dir -t deb -a native -v 4.3.1-`date +"%Y%m%d%H%M%S"` -n hyperscan --provides hyperscan --deb-user root --deb-group root -C "${BUILD_PATH}"/"${TMP_ROOT}" opt/hyperscan

PKGNAME=suricata

rm -rf "${SRC_ROOT}"/"${PKGNAME}" 2>&1 > /dev/null
rm -rf "${TMP_ROOT}" 2>&1 > /dev/null
mkdir -p "${TMP_ROOT}" 2>&1 > /dev/null

git clone https://github.com/inliniac/suricata "${SRC_ROOT}"/"${PKGNAME}" || exit 1
cd "${SRC_ROOT}"/"${PKGNAME}"

git clone https://github.com/ironbee/libhtp || exit 1
cd "${SRC_ROOT}"/"${PKGNAME}"/libhtp || exit 1
./autogen.sh
cd "${SRC_ROOT}"/"${PKGNAME}"

./autogen.sh && ./configure --prefix=/opt/suricata --enable-lua --enable-luajt --enable-geoip --enable-pie --with-libpcap-includes=/opt/snf/include --with-libpcap-libraries=/opt/snf/lib --with-libhs-includes=/opt/hyperscan/include/hs --with-libhs-libraries=/opt/hyperscan/lib || exit 1
make && make install DESTDIR="${TMP_ROOT}" || exit 1

cd "${BUILD_PATH}"
rm "${PKGNAME}"-*.x86_64.deb >/dev/null 2>&1
fpm -s dir -t deb -a native -v 3.1.999-`date +"%Y%m%d%H%M%S"` -n suricata --provides suricata --deb-user suricata --deb-group suricata -C "${TMP_ROOT}" opt/suricata || exit 1
