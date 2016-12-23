#rm -rfv heka
rm -fv heka-0_11_0-linux-amd64.rpm
#git clone https://github.com/mozilla-services/heka || exit 1
#echo "add_external_plugin(git https://github.com/mpurzynski/heka-sqs master)" >> ~/heka/cmake/plugin_loader.cmake
cd ~/heka && source ./build.sh
make package
mv /home/mpurzynski/heka/build/heka-0_11_0-linux-amd64.rpm ~/
