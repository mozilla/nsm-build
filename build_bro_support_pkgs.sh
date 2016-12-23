rm bro-support-*.x86_64.rpm >/dev/null 2>&1

fpm -s dir -t rpm -a native -v 1.1-`date +"%Y_%m_%d_%H_%M_%S"` -n bro-support --provides bro-support --pre-install ./bro-package-scripts/preinstall-bro-support.sh --post-install ./bro-package-scripts/postinstall-bro-support.sh --rpm-user bro --rpm-group bro -C ~/bro-support usr/local/sbin etc || exit 1
