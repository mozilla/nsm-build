TMP_ROOT=~/tmp/dest

rm -rf ~/pulledpork-et 2>&1 > /dev/null
rm -rf "${TMP_ROOT}" 2>&1 > /dev/null
mkdir -p "${TMP_ROOT}"/usr/local/sbin 2>&1 > /dev/null

git clone https://github.com/michalpurzynski/pulledpork-et ~/pulledpork-et

cp ~/pulledpork-et/pulledpork.pl "${TMP_ROOT}"/usr/local/sbin/
chmod 0755 "${TMP_ROOT}"/usr/local/sbin/pulledpork.pl

rm -f ~/pulledpork-et-0.7.0*.x86_64.deb 2>&1 > /dev/null

fpm -s dir -t deb -a native -v 1.0-`date +"%Y%m%d%H%M%S"` -n pulledpork-et --provides pulledpork-et --deb-user bro --deb-group bro -C "${TMP_ROOT}" usr/local/sbin || exit 1
