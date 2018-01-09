FROM base/archlinux:latest

RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm base-devel
RUN pacman -S --noconfirm make git
RUN useradd -m tmpuser
RUN echo 'tmpuser ALL=NOPASSWD: ALL' | tee -a /etc/sudoers
RUN sudo -u tmpuser bash -c 'cd ~ && git clone https://aur.archlinux.org/trizen.git && cd trizen && makepkg -si --noconfirm'
RUN sudo -u tmpuser gpg --recv-keys --keyserver hkp://pgp.mit.edu C3126D3B4AE55E93
RUN sudo -u tmpuser bash -c 'trizen -S --noconfirm cmake gcc-fortran mingw-w64-binutils mingw-w64-crt mingw-w64-gcc mingw-w64-headers mingw-w64-winpthreads doxygen graphviz texlive-core texlive-fontsextra texlive-science lapack sudo vim openmpi python-numpy python-matplotlib'
RUN echo "backend: Agg" >> /usr/lib/python3.6/site-packages/matplotlib/mpl-data/matplotlibrc
RUN git clone https://github.com/Reference-LAPACK/lapack.git; cd lapack; mkdir build; cd build; cmake -DCMAKE_SYSTEM_NAME=Windows -DCMAKE_C_COMPILER=x86_64-w64-mingw32-gcc -DCMAKE_CXX_COMPILER=x86_64-w64-mingw32-g++ -DCMAKE_RC_COMPILER=x86_64-w64-mingw32-windres -DCMAKE_Fortran_COMPILER=x86_64-w64-mingw32-gfortran -DCMAKE_FIND_ROOT_PATH=/usr/x86_64-w64-mingw32 ..; make install; cd /; rm -R lapack
RUN pacman -Scc --noconfirm
RUN texhash
RUN updmap-sys --syncwithtrees
RUN updmap-sys
RUN git clone https://github.com/scgmlz/BornAgain.git
RUN pacman -S --noconfirm eigen fftw gsl yaml-cpp libyaml boost python-yaml
RUN cd BornAgain; mkdir build; cd build; cmake -DBORNAGAIN_USE_PYTHON3=ON -DBORNAGAIN_GUI=OFF ..
RUN cd BornAgain/build; make
RUN cd BornAgain/build; make install
RUN rm -R BornAgain
RUN cat /usr/local/bin/thisbornagain.sh >> /etc/profile
