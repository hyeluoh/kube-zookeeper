FROM ubuntu
COPY --chown=root:root jdk-11.0.11+9 /usr/local/jdk-11.0.11+9/
ENV JAVA_HOME /usr/local/jdk-11.0.11+9
ENV JRE_HOME ${JAVA_HOME}/jre
ENV CLASSPATH .:${JAVA_HOME}/lib:${JRE_HOME}/lib
ENV PATH ${JAVA_HOME}/bin:$PATH
ENV LANG=en_US.utf8 \
    ARCH=amd64 \
    GNU_ARCH=x86_64-linux-gnu
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get clean 
RUN apt-get update
RUN set -x export DEBIAN_FRONTEND=noninteractive
RUN apt-get -y  install tzdata netcat-openbsd net-tools
RUN  ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime && echo "Asia/Shanghai" > /etc/timezone
RUN groupadd -g 1002 zookeeper && useradd  zookeeper -u 1002 -g zookeeper 
RUN echo "password\npassword" | passwd  -q root
RUN echo "password\npassword" | passwd  -q zookeeper
COPY --chown=zookeeper:zookeeper zookeeper /opt/zookeeper/
RUN chmod +x /opt/zookeeper/bin/* && mkdir -p /var/log/zookeeper && chown -R zookeeper:zookeeper /var/log/zookeeper && ln -snf /opt/zookeeper/bin/* /usr/bin/
