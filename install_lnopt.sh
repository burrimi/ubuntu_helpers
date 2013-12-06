wget http://ab-initio.mit.edu/nlopt/nlopt-2.4.1.tar.gz
tar -xzf nlopt-2.4.1.tar.gz
cd nlopt-2.4.1
./configure --with-cxx
make
sudo make install
cd ..
rm -rf nlopt-2.4.1
rm nlopt-2.4.1.tar.gz
