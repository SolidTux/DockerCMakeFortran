FROM fedora:latest

RUN dnf upgrade -y --refresh
RUN dnf install -y @development-tools
RUN dnf install -y mingw64-gcc-c++ mingw64-gcc-gfortran cmake doxygen texlive graphviz lapack-devel openmpi python3-numpy python3-matplotlib fftw-devel boost-devel gsl-devel libtiff-devel eigen3-devel python3-devel yaml-cpp-devel python3-yaml
RUN dnf clean all -y
RUN echo "backend: Agg" >> /usr/lib/python3.6/site-packages/matplotlib/mpl-data/matplotlibrc
RUN git clone https://github.com/Reference-LAPACK/lapack.git; cd lapack; mkdir build; cd build; cmake -DCMAKE_SYSTEM_NAME=Windows -DCMAKE_C_COMPILER=x86_64-w64-mingw32-gcc -DCMAKE_CXX_COMPILER=x86_64-w64-mingw32-g++ -DCMAKE_RC_COMPILER=x86_64-w64-mingw32-windres -DCMAKE_Fortran_COMPILER=x86_64-w64-mingw32-gfortran -DCMAKE_FIND_ROOT_PATH=/usr/x86_64-w64-mingw32 ..; make install; cd /; rm -R lapack
RUN git clone https://github.com/scgmlz/BornAgain.git
RUN cd BornAgain; mkdir build; cd build; cmake -DBORNAGAIN_USE_PYTHON3=ON -DBORNAGAIN_GUI=OFF ..
RUN cd BornAgain/build; make
RUN cd BornAgain/build; make install
RUN rm -R BornAgain
RUN cat /usr/local/bin/thisbornagain.sh >> /etc/profile
