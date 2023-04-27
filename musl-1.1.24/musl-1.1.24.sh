set -ex

mkdir build src
cd build

cp ${source_tar_gz} ../src/${name}.tar.gz
gzip -d -f ../src/${name}.tar.gz
tar xf ../src/${name}.tar
rm -r ../src
ls -R
