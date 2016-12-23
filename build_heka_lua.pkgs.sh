rm heka-nsm-lua*.rpm >/dev/null 2>&1

fpm -s dir -t rpm -a native -v 2.6-`date +"%Y_%m_%d_%H_%M_%S"` -n heka-nsm-lua --provides heka-nsm-lua --pre-install ./bro-package-scripts/preinstall-heka-nsm-lua.sh --post-install ./bro-package-scripts/postinstall-heka-nsm-lua.sh --rpm-user root --rpm-group root -C ~/heka-nsm-lua usr/share/heka || exit 1
