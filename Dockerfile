FROM centos:7.9.2009

WORKDIR /opt

ADD jdk-8u311-linux-x64.tar.gz /usr/local/
ADD apache-doris-1.0.0-incubating-bin.tar.gz /opt

ENV LANG=zh_CN.UTF-8 \
LANGUAGE=zh_CN:zh
ENV JAVA_HOME /usr/local/jdk1.8.0_311
ENV JRE_HOME $JAVA_HOME/jre
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib:$CLASSPATH
ENV PATH $JAVA_HOME/bin:$PATH
ENV DORIS_HOME /opt/doris/be
# Install tools

RUN yum install -y telnet curl net-tools && \
yum clean all && \
rm -rf /tmp/* rm -rf /var/cache/yum/* && \
localedef -c -f UTF-8 -i zh_CN zh_CN.UTF-8 && \
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
mv apache-doris-1.0.0-incubating-bin/ doris/ && \
echo 'priority_networks = ${FE_IPADDRESS}/24' >> doris/fe/conf/fe.conf && \
echo 'priority_networks = ${BE_IPADDRESS}/24' >> doris/be/conf/be.conf

# Define default command.
CMD ["tail -f /dev/null"]