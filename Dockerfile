FROM centos:7

# Goss
ENV GOSS_VERSION=0.3.1
ENV GOSS_FILE=goss
ENV GOSS_INSTALL_DIR=/opt

# Java
ENV JAVA_VERSION=1.8.0
ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}/jre

# Gradle
ENV GRADLE_VERSION=2.6
ENV GRADLE_INSTALL_DIR=/opt
ENV GRADLE_BIN=${GRADLE_INSTALL_DIR}/gradle-${GRADLE_VERSION}/bin
ENV PATH $PATH:${GRADLE_BIN}

# Install Dependancies
WORKDIR ${GRADLE_INSTALL_DIR}
RUN yum -y update
RUN yum -y --nogpgcheck install curl wget gcc-c++ make java-${JAVA_VERSION}-openjdk-devel

# Install Gradle and Set PATH
RUN wget -qO- https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip | jar xvf /dev/stdin
RUN chmod +x ${GRADLE_BIN}/gradle

#Install Goss Validation Testing Framework
WORKDIR ${GOSS_INSTALL_DIR}
RUN curl -sSL -o ${GOSS_INSTALL_DIR}/${GOSS_FILE} https://github.com/aelsabbahy/goss/releases/download/v${GOSS_VERSION}/goss-linux-amd64 \
    && chmod +x ${GOSS_INSTALL_DIR}/${GOSS_FILE} \
    && ln -s ${GOSS_INSTALL_DIR}/${GOSS_FILE} /usr/local/bin/goss

# Cleanup
RUN rm -rf *.rpm
RUN rm -rf *.zip
RUN yum -y clean all
