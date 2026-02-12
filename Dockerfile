FROM rockylinux/rockylinux:10

RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.aliyun.com/rockylinux|g' \
    -i.bak \
    /etc/yum.repos.d/rocky*.repo &&\
    dnf makecache

COPY ./RLM_Linux-64 /tmp/RLM_Linux-64

RUN  dnf install -y sudo libxcrypt-compat &&\
     cd /tmp/RLM_Linux-64 &&\
     chmod +x rlm_install.sh &&\
     ./rlm_install.sh &&\
     rm -rf /tmp/RLM_Linux-64

COPY ./yeti.lic /opt/rlm/yeti.lic
COPY ./peregrinel.lic /opt/rlm/peregrinel.lic
COPY ./peregrinel.set /opt/rlm/peregrinel.set
COPY ./zivadyn.lic /opt/rlm/zivadyn.lic
COPY ./zivadyn.set /opt/rlm/zivadyn.set
COPY ./genarts.lic /opt/rlm/genarts.lic

RUN port=6001; \
    for product in foundry fabricinc genarts golaem innobright mootzoid nextlimit peregrinel redshift sfx solidangle peregrinel zivadyn; do \
        sed -i.bak "s|ISV ${product}|ISV ${product} port=${port}|g" /opt/rlm/${product}.lic; \
        port=$((port + 1)); \
    done

ENV TZ=Asia/Shanghai

EXPOSE 5053 5054 6001-6015

WORKDIR /opt/rlm

ENTRYPOINT ["./rlm", "-c", "./solidangle.lic"]
