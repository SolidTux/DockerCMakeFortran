FROM base/archlinux:latest

RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm base-devel
RUN pacman -S --noconfirm make git cmake gcc gcc-fortran mingw-w64-binutils mingw-w64-crt mingw-w64-gcc mingw-w64-headers mingw-w64-winpthreads doxygen graphviz pandoc texlive-bibtexextra texlive-bin texlive-core texlive-fontsextra texlive-formatsextra texlive-games texlive-humanities texlive-langchinese texlive-langcyrillic texlive-langextra texlive-langgreek texlive-langjapanese texlive-langkorean texlive-latexextra texlive-music texlive-pictures texlive-pstricks texlive-publishers texlive-science lapack sudo vim openmpi python-numpy
RUN useradd -m tmpuser
RUN echo 'tmpuser ALL=NOPASSWD: ALL' | tee -a /etc/sudoers
RUN sudo -u tmpuser gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
RUN sudo -u tmpuser bash -c 'cd ~ && git clone https://aur.archlinux.org/cower.git && cd cower && makepkg -si --noconfirm'
RUN sudo -u tmpuser bash -c 'cd ~ && git clone https://aur.archlinux.org/pacaur.git && cd pacaur && makepkg -si --noconfirm'
RUN sudo -u tmpuser bash -c 'EDITOR=vim pacaur -S --noconfirm --noedit mingw-w64-lapack'
RUN userdel tmpuser
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
RUN cat /usr/local/bin/thisbornagain.sh | tee /etc/profile
