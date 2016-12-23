TMP_ROOT=~/tmp/dest

rm -rf "${TMP_ROOT}" 2>&1 > /dev/null
mkdir -p "${TMP_ROOT}/home/mozdef/envs/mozdef" 2>&1 > /dev/null
cp -av ~/mozdef/* "${TMP_ROOT}/home/mozdef/envs/mozdef" 2>&1 > /dev/null

rm -f ~/nsm-mozdef-frontend_1.0_amd64.deb 2>&1 > /dev/null

fpm -s dir -t deb -a native -v 1.0-`date +"%Y%m%d%H%M%S"` -n nsm-mozdef-frontend --provides nsm-mozdef-frontend --deb-user mozdef --deb-group mozdef -C "${TMP_ROOT}" . || exit 1
