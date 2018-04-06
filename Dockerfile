# debian:9.4 - linux; amd64
# https://github.com/docker-library/repo-info/blob/master/repos/debian/tag-details.md#debian94---linux-amd64
FROM debian@sha256:316ebb92ca66bb8ddc79249fb29872bece4be384cb61b5344fac4e84ca4ed2b2

ARG AWS_JAVA_SDK_JAR_SHA1="650f07e69b071cbf41c32d4ea35fd6bbba8e6793"
ARG AWS_JAVA_SDK_URL="https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk"
ARG AWS_JAVA_SDK_VERSION="1.7.5"
ARG BUILD_DATE
ARG CODENAME="stretch"
ARG CONDA_DIR="/opt/conda"
ARG CONDA_ENV_YML="spark-root-conda-base-env.yml"
ARG CONDA_INSTALLER="Miniconda3-4.3.31-Linux-x86_64.sh"
ARG CONDA_MD5="7fe70b214bee1143e3e3f0467b71453c"
ARG CONDA_URL="https://repo.continuum.io/miniconda"
ARG DCOS_COMMONS_URL="https://downloads.mesosphere.com/dcos-commons"
ARG DCOS_COMMONS_VERSION="0.40.5"
ARG DISTRO="debian"
ARG DEBCONF_NONINTERACTIVE_SEEN="true"
ARG DEBIAN_FRONTEND="noninteractive"
ARG GPG_KEYSERVER="hkps://zimmermann.mayfirst.org"
ARG HADOOP_AWS_JAR_SHA1="cfb9d10d22cccdfcb98345c1861912aec86710c8"
ARG HADOOP_AWS_URL="https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws"
ARG HADOOP_AWS_VERSION="2.7.5"
ARG HADOOP_HDFS_HOME="/opt/hadoop"
ARG HADOOP_MAJOR_VERSION="2.7"
ARG HADOOP_SHA256="0bfc4d9b04be919be2fdf36f67fa3b4526cdbd406c512a7a1f5f1b715661f831"
ARG HADOOP_URL="http://www-us.apache.org/dist/hadoop/common"
ARG HADOOP_VERSION="2.7.5"
ARG JAVA_HOME="/opt/jdk"
ARG JAVA_URL="https://downloads.mesosphere.com/java"
ARG JAVA_VERSION="8u162"
ARG LANG="en_US.UTF-8"
ARG LANGUAGE="en_US.UTF-8"
ARG LC_ALL="en_US.UTF-8"
ARG LIBMESOS_BUNDLE_SHA256="bd4a785393f0477da7f012bf9624aa7dd65aa243c94d38ffe94adaa10de30274"
ARG LIBMESOS_BUNDLE_URL="https://downloads.mesosphere.com/libmesos-bundle"
ARG LIBMESOS_BUNDLE_VERSION="1.11.0"
ARG MESOSPHERE_PREFIX="/opt/mesosphere"
ARG MESOS_JAR_SHA1="0cef8031567f2ef367e8b6424a94d518e76fb8dc"
ARG MESOS_MAVEN_URL="https://repo1.maven.org/maven2/org/apache/mesos/mesos"
ARG MESOS_PROTOBUF_JAR_SHA1="189ef74959049521be8f5a1c3de3921eb0117ffb"
ARG MESOS_VERSION="1.5.0"
ARG REPO="http://cdn-fastly.deb.debian.org"
ARG SPARK_DIST_URL="https://downloads.mesosphere.com/spark"
ARG SPARK_HOME="/opt/spark"
ARG SPARK_VERSION="2.2.1-2"
ARG TENSORFLOW_SERVING_APT_URL="http://storage.googleapis.com/tensorflow-serving-apt"
ARG TENSORFLOW_SERVING_VERSION=1.5.0
ARG VCS_REF
ARG SPARK_DCOS_VERSION="2.2.1-1.11.0"

LABEL maintainer="Vishnu Mohan <vishnu@mesosphere.com>" \
      org.label-schema.build-date="${BUILD_DATE}" \
      org.label-schema.name="Apache Spark" \
      org.label-schema.description="Apache Spark is a fast and general engine for large-scale data processing" \
      org.label-schema.url="http://spark.apache.org" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.vcs-url="https://github.com/vishnu2kmohan/spark-dcos-docker" \
      org.label-schema.version="${SPARK_DCOS_VERSION}" \
      org.label-schema.schema-version="1.0"

ENV BOOTSTRAP="${MESOSPHERE_PREFIX}/bin/bootstrap" \
    CODENAME=${CODENAME:-"stretch"} \
    CONDA_DIR=${CONDA_DIR:-"/opt/conda"} \
    DEBCONF_NONINTERACTIVE_SEEN=${DEBCONF_NONINTERACTIVE_SEEN:-"true"} \
    DEBIAN_FRONTEND=${DEBIAN_FRONTEND:-"noninteractive"} \
    DISTRO=${DISTRO:-"debian"} \
    GPG_KEYSERVER=${GPG_KEYSERVER:-"hkps://zimmermann.mayfirst.org"} \
    HADOOP_HDFS_HOME=${HADOOP_HDFS_HOME:-"/opt/hadoop"} \
    JAVA_HOME=${JAVA_HOME:-"/opt/jdk"} \
    LANG=${LANG:-"en_US.UTF-8"} \
    LANGUAGE=${LANGUAGE:-"en_US.UTF-8"} \
    LC_ALL=${LC_ALL:-"en_US.UTF-8"} \
    MESOSPHERE_PREFIX=${MESOSPHERE_PREFIX:-"/opt/mesosphere"} \
    MESOS_AUTHENTICATEE="com_mesosphere_dcos_ClassicRPCAuthenticatee" \
    MESOS_HTTP_AUTHENTICATEE="com_mesosphere_dcos_http_Authenticatee" \
    MESOS_MODULES="{\"libraries\": [{\"file\": \"libdcos_security.so\", \"modules\": [{\"name\": \"com_mesosphere_dcos_ClassicRPCAuthenticatee\"}]}]}" \
    MESOS_NATIVE_LIBRARY="${MESOSPHERE_PREFIX}/libmesos-bundle/lib/libmesos.so" \
    MESOS_NATIVE_JAVA_LIBRARY="${MESOSPHERE_PREFIX}/libmesos-bundle/lib/libmesos.so" \
    PATH="${JAVA_HOME}/bin:${SPARK_HOME}/bin:${CONDA_DIR}/bin:${MESOSPHERE_PREFIX}/bin:${PATH}" \
    SHELL="/bin/bash" \
    SPARK_HOME=${SPARK_HOME:-"/opt/spark"}

RUN echo "deb ${REPO}/${DISTRO} ${CODENAME} main" \
         >> /etc/apt/sources.list \
    echo "deb ${REPO}/${DISTRO}-security ${CODENAME}/updates main" \
         >> /etc/apt/sources.list \
    && apt-get update -yq --fix-missing \
    && apt-get install -yq --no-install-recommends locales \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && apt-get install -yq --no-install-recommends apt-utils \
    && apt-get -yq dist-upgrade \
    && apt-get install -yq --no-install-recommends \
       bash-completion \
       bzip2 \
       ca-certificates \
       curl \
       dirmngr \
       git \
       gnupg \
       jq \
       less \
       nginx \
       openssh-client \
       procps \
       r-base \
       rsync \
       runit \
       sudo \
       unzip \
       vim \
       wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && usermod -u 99 nobody \
    && addgroup --gid 99 nobody \
    && usermod -g nobody nobody \
    && echo "nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin" >> /etc/passwd

RUN cd /tmp \
    && mkdir -p "${CONDA_DIR}" "${HADOOP_HDFS_HOME}" "${JAVA_HOME}" "${MESOSPHERE_PREFIX}/bin" "${SPARK_HOME}" \
    && curl --retry 3 -fsSL -O "${LIBMESOS_BUNDLE_URL}/libmesos-bundle-${LIBMESOS_BUNDLE_VERSION}.tar.gz" \
    && echo "${LIBMESOS_BUNDLE_SHA256}" "libmesos-bundle-${LIBMESOS_BUNDLE_VERSION}.tar.gz" | sha256sum -c - \
    && tar xf "libmesos-bundle-${LIBMESOS_BUNDLE_VERSION}.tar.gz" -C "${MESOSPHERE_PREFIX}" \
    && cd "${MESOSPHERE_PREFIX}/libmesos-bundle/lib" \
    && curl --retry 3 -fsSL -O "${MESOS_MAVEN_URL}/${MESOS_VERSION}/mesos-${MESOS_VERSION}.jar" \
    && echo "${MESOS_JAR_SHA1} mesos-${MESOS_VERSION}.jar" | sha1sum -c - \
    && curl --retry 3 -fsSL -O "${MESOS_MAVEN_URL}/${MESOS_VERSION}/mesos-${MESOS_VERSION}-shaded-protobuf.jar" \
    && echo "${MESOS_PROTOBUF_JAR_SHA1} mesos-${MESOS_VERSION}-shaded-protobuf.jar" | sha1sum -c - \
    && cd /tmp \
    && curl --retry 3 -fsSL -O "${DCOS_COMMONS_URL}/artifacts/${DCOS_COMMONS_VERSION}/bootstrap.zip" \
    && unzip "bootstrap.zip" -d "${MESOSPHERE_PREFIX}/bin/" \
    && curl --retry 3 -fsSL -O "${JAVA_URL}/server-jre-${JAVA_VERSION}-linux-x64.tar.gz" \
    && tar xf "server-jre-${JAVA_VERSION}-linux-x64.tar.gz" -C "${JAVA_HOME}" --strip-components=1 \
    && curl --retry 3 -fsSL -O "${HADOOP_URL}/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
    && echo "${HADOOP_SHA256}" "hadoop-${HADOOP_VERSION}.tar.gz" | sha256sum -c - \
    && tar xf "hadoop-${HADOOP_VERSION}.tar.gz" -C "${HADOOP_HDFS_HOME}" --strip-components=1 \
    && curl --retry 3 -fsSL -O "${SPARK_DIST_URL}/assets/spark-${SPARK_VERSION}-bin-${HADOOP_MAJOR_VERSION}.tgz" \
    && tar xf "spark-${SPARK_VERSION}-bin-${HADOOP_MAJOR_VERSION}.tgz" -C "${SPARK_HOME}" --strip-components=1 \
    && cd "${SPARK_HOME}/jars" \
    && curl --retry 3 -fsSL -O "${AWS_JAVA_SDK_URL}/${AWS_JAVA_SDK_VERSION}/aws-java-sdk-${AWS_JAVA_SDK_VERSION}.jar" \
    && echo "${AWS_JAVA_SDK_JAR_SHA1} aws-java-sdk-${AWS_JAVA_SDK_VERSION}.jar" | sha1sum -c - \
    && curl --retry 3 -fsSL -O "${HADOOP_AWS_URL}/${HADOOP_AWS_VERSION}/hadoop-aws-${HADOOP_AWS_VERSION}.jar" \
    && echo "${HADOOP_AWS_JAR_SHA1} hadoop-aws-${HADOOP_AWS_VERSION}.jar" | sha1sum -c - \
    && rm -rf /tmp/*

RUN echo "deb [arch=amd64] ${TENSORFLOW_SERVING_APT_URL} stable tensorflow-model-server tensorflow-model-server-universal" > /etc/apt/sources.list.d/tensorflow-serving.list \
    && curl --retry 3 -fsSL ${TENSORFLOW_SERVING_APT_URL}/tensorflow-serving.release.pub.gpg | apt-key add - \
    && apt-get update \
    && TENSORFLOW_SERVING_DEB="$(mktemp)" \
    && curl --retry 3 -fsSL "${TENSORFLOW_SERVING_APT_URL}/pool/tensorflow-model-server-${TENSORFLOW_SERVING_VERSION}/t/tensorflow-model-server/tensorflow-model-server_${TENSORFLOW_SERVING_VERSION}_all.deb" -o "${TENSORFLOW_SERVING_DEB}"\
    && dpkg -i "${TENSORFLOW_SERVING_DEB}" \
    && rm -f "${TENSORFLOW_SERVING_DEB}" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY "${CONDA_ENV_YML}" "${CONDA_DIR}/"

RUN cd /tmp \
    && curl --retry 3 -fsSL -O "${CONDA_URL}/${CONDA_INSTALLER}" \
    && echo "${CONDA_MD5}  ${CONDA_INSTALLER}" | md5sum -c - \
    && bash "./${CONDA_INSTALLER}" -u -b -p "${CONDA_DIR}" \
    && ${CONDA_DIR}/bin/conda config --system --prepend channels conda-forge \
    && ${CONDA_DIR}/bin/conda config --system --set auto_update_conda false \
    && ${CONDA_DIR}/bin/conda config --system --set show_channel_urls true \
    && ${CONDA_DIR}/bin/conda update --json --all -yq \
    && ${CONDA_DIR}/bin/conda env update --json -q -f "${CONDA_DIR}/${CONDA_ENV_YML}" \
    && ${CONDA_DIR}/bin/conda clean --json -tipsy \
    && rm -rf /tmp/*

COPY runit/service /var/lib/runit/service
COPY runit/init.sh /sbin/init.sh
COPY nginx /etc/nginx
COPY krb5.conf.mustache /etc/
COPY conf/ "${SPARK_HOME}/conf/"
COPY profile "/root/.profile"
COPY bash_profile "/root/.bash_profile"
COPY bashrc "/root/.bashrc"
COPY dircolors "/root/.dircolors"

RUN mkdir -p /var/lib/nginx \
    && ln -s /var/lib/runit/service/spark /etc/service/spark \
    && ln -s /var/lib/runit/service/nginx /etc/service/nginx \
    && chmod -R ugo+rw /var/lib/runit/service \
    && chmod -R ugo+rw /etc/service \
    && chmod -R ugo+rw /etc/nginx \
    && chmod -R ugo+rw /var/lib/nginx \
    && chmod -R ugo+rw /var/log/nginx \
    && chmod -R ugo+rw /var/run \
    && chmod -R ugo+rw "${SPARK_HOME}/conf" \
    && cp "${CONDA_DIR}/share/examples/krb5/krb5.conf" /etc \
    && chmod ugo+rw /etc/krb5.conf

ENV LD_LIBRARY_PATH="${MESOSPHERE_PREFIX}/libmesos-bundle/lib:${JAVA_HOME}/jre/lib/amd64/server"

WORKDIR "${SPARK_HOME}"
