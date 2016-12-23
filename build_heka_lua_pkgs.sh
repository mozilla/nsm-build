rm heka-nsm-lua*.deb >/dev/null 2>&1

fpm -s dir -t deb -a native -v 2.6-`date +"%Y%m%d%H%M%S"` -n heka-nsm-lua --provides heka-nsm-lua --deb-user root --deb-group root -C ~/heka-nsm-lua usr/share/heka || exit 1
