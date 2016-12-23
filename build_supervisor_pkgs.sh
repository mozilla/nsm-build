rm -fv python-meld3*.rpm
rm -fv python-supervisor*.rpm
fpm -s python -t rpm meld3 || exit 1
fpm --post-install ~/bro-package-scripts/postinstall-supervisor.sh -s python -t rpm supervisor || exit 1
