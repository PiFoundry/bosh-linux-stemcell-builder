# bosh/os-image-stemcell-builder

FROM ruurdk/main-ruby-go

RUN groupadd -g 1000 ubuntu && useradd -u 1000 -g 1000 -m ubuntu && echo 'ubuntu ALL=NOPASSWD:ALL' >> /etc/sudoers

ADD scripts/update.sh /tmp/update.sh
RUN /tmp/update.sh && rm /tmp/update.sh

#ENV OVF_TOOL_INSTALLER VMware-ovftool-4.1.0-2459827-lin.x86_64.bundle
#ENV OVF_TOOL_INSTALLER_SHA1 b907275c8d744bb54717d24bb8d414b19684fed4
#ADD ${OVF_TOOL_INSTALLER} /tmp/ovftool_installer.bundle
#ADD scripts/install-ovf.sh /tmp/install-ovf.sh
#RUN /tmp/install-ovf.sh && rm /tmp/install-ovf.sh

RUN go get github.com/dpb587/metalink \
    && cd /root/go/src/github.com/dpb587/metalink/ \
    && go build -o /usr/bin/meta4 \
    && chmod +x /usr/bin/meta4 \
    && rm -rf /root/go

# add bsdtar because of a bug with tar in docker + overlayfs: https://github.com/coreos/bugs/issues/1095#issuecomment-292664145
RUN apt-get install -y m4 libtool autoconf pkg-config \
    && wget https://www.libarchive.org/downloads/libarchive-3.3.1.tar.gz \
    && tar xzf libarchive-3.3.1.tar.gz \
    && cd libarchive-3.3.1 \
    && ./build/autogen.sh \
    && ./configure \
    && make \
    && make install 
# dont override tar executable, it will break dpkg -i in stemcell builder tasks, it seems we have no choice but to make bsdtar explicit in the stemcell parts\
#    && cp $(which tar) $(which tar)~ \
#    && ln -sf $(which bsdtar) $(which tar)
# this can be restored with: RUN mv $(which tar)~ $(which tar)

# this is unshare from raspbian stretch so we can use the newer -fp flags
ADD scripts/unshare /usr/bin/unshare

ADD scripts/ubuntu_bashrc /home/ubuntu/.bashrc

RUN for GO_EXECUTABLE in $GOROOT/bin/*; do ln -s $GO_EXECUTABLE /usr/bin/; done
