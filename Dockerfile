FROM rockylinux:8

RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.aliyun.com/rockylinux|g' \
    -i.bak \
    /etc/yum.repos.d/[Rr]ocky*.repo &&\
    dnf makecache

COPY ./RLM_Linux-64 /root/RLM_Linux-64

RUN  dnf install -y sudo &&\
     cd /root/RLM_Linux-64 &&\
     chmod +x rlm_install.sh &&\
     ./rlm_install.sh &&\
     rm -rf /root/RLM_Linux-64 &&\
     cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
     echo 'Asia/Shanghai' >/etc/timezone

COPY ./yeti.lic /opt/rlm/yeti.lic

RUN sed -e 's|ISV foundry|ISV foundry port=6001|g' -i.bak /opt/rlm/foundry.lic &&\
    sed -e 's|ISV fabricinc|ISV fabricinc port=6002|g' -i.bak /opt/rlm/fabricinc.lic &&\
    sed -e 's|ISV genarts|ISV genarts port=6003|g' -i.bak /opt/rlm/genarts.lic &&\
    sed -e 's|ISV golaem|ISV golaem port=6004|g' -i.bak /opt/rlm/golaem.lic  &&\
    sed -e 's|ISV innobright|ISV innbright port=6005|g' -i.bak /opt/rlm/innobright.lic &&\
    sed -e 's|ISV mootzoid|ISV mootzoid port=6006|g' -i.bak /opt/rlm/mootzoid.lic &&\
    sed -e 's|ISV nextlimit|ISV nextlimit port=6007|g' -i.bak /opt/rlm/nextlimit.lic &&\
    sed -e 's|ISV peregrinel|ISV peregrinel port=6008|g' -i.bak /opt/rlm/peregrinel.lic &&\
    sed -e 's|ISV redshift|ISV redshift port=6009|g' -i.bak /opt/rlm/redshift.lic &&\
    sed -e 's|ISV sfx|ISV sfx port=6010|g' -i.bak /opt/rlm/sfx_server.lic &&\
    sed -e 's|ISV solidangle|ISV solidangle port=6011|g' -i.bak /opt/rlm/solidangle.lic &&\
    sed -e 's|ISV peregrinel|ISV peregrinel port=6012|g' -i.bak /opt/rlm/yeti.lic

EXPOSE 5053 5054 6001-6015

WORKDIR /opt/rlm

ENTRYPOINT ["./rlm", "-c", "./solidangle.lic"]
