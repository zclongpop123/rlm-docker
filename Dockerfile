FROM centos

COPY ./RLM_Linux-64 /root/RLM_Linux-64

RUN  yum install -y sudo &&\
     cd /root/RLM_Linux-64 &&\
     chmod +x rlm_install.sh &&\
     ./rlm_install.sh &&\
     rm -rf /root/RLM_Linux-64

EXPOSE 5053 5054

CMD /opt/rlm/rlm -c /opt/rlm/solidangle.lic -dlog +/opt/rlm/rlm_lic.dlog
