. ./common.sh

PKGNAME=bro-2.5.9999

rm -rf "${SRC_ROOT}"/"${PKGNAME}" 2>&1 > /dev/null
rm -rf "${TMP_ROOT}" 2>&1 > /dev/null
mkdir -p "${TMP_ROOT}" 2>&1 > /dev/null

cd "${BUILD_PATH}" && git clone --recursive git://git.bro.org/bro "${SRC_ROOT}"/"${PKGNAME}"
#cd "${SRC_ROOT}" && curl -O https://www.bro.org/downloads/bro-2.5.tar.gz && tar zxf bro-2.5.tar.gz
cd "${SRC_ROOT}"/"${PKGNAME}" && ./configure --prefix=/opt/bro --with-pcap=/opt/snf --with-libcaf=/opt/libcaf || exit 1
make install DESTDIR="${TMP_ROOT}" || exit 1
cd "${BUILD_PATH}"

rm "${PKGNAME}"-*.x86_64.deb >/dev/null 2>&1
rm -f "${TMP_ROOT}"/opt/bro/etc/*.cfg >/dev/null 2>&1 || exit 1
rm -f "${TMP_ROOT}"/opt/bro/share/bro/site/local.bro >/dev/null 2>&1 || exit 1
#rm -f "${TMP_ROOT}"/opt/bro/share/bro/site/*.bro >/dev/null 2>&1 || exit 1
#rm -rf "${TMP_ROOT}"/opt/bro/lib/bro/plugins/* >/dev/null 2>&1 || exit 1

for i in "${TMP_ROOT}"/nsm/bro/logs "${TMP_ROOT}"/nsm/bro/spool "${TMP_ROOT}"/home/bro/run "${TMP_ROOT}"/home/bro/tmp "${TMP_ROOT}"/opt/bro/share/bro/brozilla "${TMP_ROOT}"/opt/bro/share/bro/intelzilla "${TMP_ROOT}"/var/log/nsm "${TMP_ROOT}"/etc/cron.d; do
	mkdir -p "${i}"
done;

bash -c "echo '*/5 * * * * bro /opt/bro/bin/broctl cron >> /var/log/nsm/broctlcron.log 2>&1' > ${TMP_ROOT}/etc/cron.d/broctl"

cd "${BRO_PKG}"
source bin/activate
"${BRO_PKG}"/bin/bro-pkg install bro-af_packet-plugin
"${BRO_PKG}"/bin/bro-pkg install bro-myricom
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
unset VIRTUAL_ENV
export PATH
cd "${BUILD_PATH}"

fpm -s dir -t deb -a native -v 2.5-`date +"%Y%m%d%H%M%S"` -n bro --provides bro --deb-user bro --deb-group bro -C "${TMP_ROOT}" opt/bro etc/cron.d/broctl nsm var/log/nsm home/bro/run home/bro/tmp || exit 1
