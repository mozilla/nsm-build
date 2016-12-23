rm -fv supervisor-support-*.rpm >/dev/null 2>&1

fpm -s dir -t rpm -a native -v 1.0-`date +"%Y_%m_%d_%H_%M_%S"` -n supervisor-support --provides supervisor-support --pre-install ./bro-package-scripts/preinstall-supervisor-support.sh --post-install ./bro-package-scripts/postinstall-supervisor-support.sh --rpm-user root --rpm-group root -C ~/supervisor-support etc || exit 1
