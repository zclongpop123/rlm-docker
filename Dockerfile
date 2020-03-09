# magnet:?xt=urn:btih:E78DA694801A635217CA1178811C72DF2C7259CA

FROM centos

COPY ./RLM_Linux-64 /root/RLM_Linux-64


RUN  yum install -y sudo &&\
     cd /root/RLM_Linux-64 &&\
     chmod +x rlm_install.sh &&\
     ./rlm_install.sh &&\
     rm -rf /root/RLM_Linux-64


EXPOSE 5053 5054

WORKDIR /opt/rlm
CMD ./rlm -c ./solidangle.lic -dlog +./rlm_lic.dlog
