# debian:9.4 - linux; amd64
# https://github.com/docker-library/repo-info/blob/master/repos/debian/tag-details.md#debian94---linux-amd64
FROM debian@sha256:316ebb92ca66bb8ddc79249fb29872bece4be384cb61b5344fac4e84ca4ed2b2

ARG BUILD_DATE
ARG CODENAME="stretch"
ARG CONDA_DIR="/opt/conda"
ARG CONDA_ENV_YML="spark-root-conda-base-env.yml"
ARG CONDA_INSTALLER="Miniconda3-4.5.4-Linux-x86_64.sh"
ARG CONDA_MD5="a946ea1d0c4a642ddf0c3a26a18bb16d"
ARG CONDA_URL="https://repo.continuum.io/miniconda"
ARG DCOS_COMMONS_URL="https://downloads.mesosphere.com/dcos-commons"
ARG DCOS_COMMONS_VERSION="0.50.0"
ARG DEBCONF_NONINTERACTIVE_SEEN="true"
ARG DEBIAN_FRONTEND="noninteractive"
ARG DEBIAN_REPO="http://cdn-fastly.deb.debian.org"
ARG DISTRO="debian"
ARG GPG_KEYSERVER="hkps://zimmermann.mayfirst.org"
ARG HADOOP_HDFS_HOME="/opt/hadoop"
ARG HADOOP_MAJOR_VERSION="2.9"
ARG HADOOP_SHA256="eed6015a123644d3b4247bac58770e4a8b31340fa62721987430e15a0dd942fc"
ARG HADOOP_URL="http://www-us.apache.org/dist/hadoop/common"
ARG HADOOP_VERSION="2.9.1"
ARG HOME="/root"
ARG JAVA_HOME="/opt/jdk"
ARG JAVA_URL="https://downloads.mesosphere.com/java"
ARG JAVA_VERSION="8u172"
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
ARG SPARK_DCOS_VERSION="2.2.1-1.11.3"
ARG SPARK_DIST_SHA256="52e29e83a65688e29da975d1ace7815c6a5b55e76c41d43a28e5e80de2b29843"
ARG SPARK_DIST_URL="https://s3.amazonaws.com/vishnu-mohan/spark"
ARG SPARK_HOME="/opt/spark"
ARG SPARK_MAJOR_VERSION="2.2"
ARG SPARK_VERSION="2.2.1"
ARG TENSORFLOW_ECO_URL="https://s3.amazonaws.com/vishnu-mohan/tensorflow"
ARG TENSORFLOW_HADOOP_JAR_SHA256="cb77cc942a477fb0dbc6b7d17ee1cb0a0a73ba827f288db4c749d5fc0a0c5be3"
ARG TENSORFLOW_SPARK_JAR_SHA256="303e8d5a8e2e9bad059435d4a86d03a71b3be00d661acba3c5b8f524f20b30fc"
ARG TENSORFLOW_JAR_SHA256="4b6a9d76ea853db41532275a3608d2d1b5abc1c16609cf8b9ebfffef7c3036fc"
ARG TENSORFLOW_JNI_SHA256="894d39d8e1d8d1329ea7153f8624657d27619c5db1d9535ab6b66296e3e6ee45"
ARG TENSORFLOW_SERVING_APT_URL="http://storage.googleapis.com/tensorflow-serving-apt"
ARG TENSORFLOW_SERVING_VERSION="1.5.0"
ARG TENSORFLOW_URL="https://storage.googleapis.com/tensorflow"
ARG TENSORFLOW_VARIANT="cpu"
ARG TENSORFLOW_VERSION="1.8.0"
ARG VCS_REF
ARG XGBOOST_JAVA_JAR_SHA256="4a6599ee3f1bd10d984e8b03747d5bc3cb637aeb791474178de2c285857bf69e"
ARG XGBOOST_SPARK_JAR_SHA256="cd31fb96b26fee197e126215949bc4f5c9a3cafd7ff157ab0037a63777c2935e"
ARG XGBOOST_URL="https://s3.amazonaws.com/vishnu-mohan/xgboost"
ARG XGBOOST_VERSION="0.71"

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
    HOME=${HOME:-"/root"} \
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
    PATH="${JAVA_HOME}/bin:${SPARK_HOME}/bin:${HADOOP_HDFS_HOME}/bin:${CONDA_DIR}/bin:${MESOSPHERE_PREFIX}/bin:${PATH}" \
    SHELL="/bin/bash" \
    SPARK_HOME=${SPARK_HOME:-"/opt/spark"}

RUN echo "deb ${DEBIAN_REPO}/${DISTRO} ${CODENAME} main" >> /etc/apt/sources.list \
    && echo "deb ${DEBIAN_REPO}/${DISTRO}-security ${CODENAME}/updates main" >> /etc/apt/sources.list \
    && apt-get update -yq --fix-missing \
    && apt-get install -yq --no-install-recommends locales \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && apt-get install -yq --no-install-recommends apt-transport-https apt-utils \
    && apt-get -yq dist-upgrade \
    && apt-get install -yq --no-install-recommends \
       bash-completion \
       bzip2 \
       ca-certificates \
       curl \
       dirmngr \
       dnsutils \
       git \
       gnupg \
       jq \
       kstart \
       less \
       netcat \
       nginx \
       openssh-client \
       procps \
       psmisc \
       rsync \
       runit \
       sssd \
       sudo \
       unzip \
       vim \
       wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && addgroup --gid 99 nobody \
    && usermod -u 99 -g 99 nobody \
    && echo "nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin" >> /etc/passwd \
    && usermod -a -G users nobody

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
    && rm -rf "${HADOOP_HDFS_HOME}/share/doc" \
    && curl --retry 3 -fsSL -O "${SPARK_DIST_URL}/spark-${SPARK_VERSION}-bin.tgz" \
    && echo "${SPARK_DIST_SHA256}" "spark-${SPARK_VERSION}-bin.tgz" | sha256sum -c - \
    && tar xf "spark-${SPARK_VERSION}-bin.tgz" -C "${SPARK_HOME}" --strip-components=1 \
    && cd "${SPARK_HOME}/jars" \
    && curl --retry 3 -fsSL -O "${XGBOOST_URL}/${XGBOOST_VERSION}/xgboost4j-${XGBOOST_VERSION}.jar" \
    && echo "${XGBOOST_JAVA_JAR_SHA256}" "xgboost4j-${XGBOOST_VERSION}.jar" | sha256sum -c - \
    && curl --retry 3 -fsSL -O "${XGBOOST_URL}/${XGBOOST_VERSION}/xgboost4j-spark-${XGBOOST_VERSION}.jar" \
    && echo "${XGBOOST_SPARK_JAR_SHA256}" "xgboost4j-spark-${XGBOOST_VERSION}.jar" | sha256sum -c - \
    && curl --retry 3 -fsSL -O "${TENSORFLOW_URL}/libtensorflow/libtensorflow-${TENSORFLOW_VERSION}.jar" \
    && echo "${TENSORFLOW_JAR_SHA256}" "libtensorflow-${TENSORFLOW_VERSION}.jar" | sha256sum -c - \
    && curl --retry 3 -fsSL -O "${TENSORFLOW_ECO_URL}/${TENSORFLOW_VERSION}/hadoop-${HADOOP_MAJOR_VERSION}/tensorflow-hadoop-${TENSORFLOW_VERSION}.jar" \
    && echo "${TENSORFLOW_HADOOP_JAR_SHA256}" "tensorflow-hadoop-${TENSORFLOW_VERSION}.jar" | sha256sum -c - \
    && curl --retry 3 -fsSL -O "${TENSORFLOW_ECO_URL}/${TENSORFLOW_VERSION}/spark-${SPARK_MAJOR_VERSION}/spark-tensorflow-connector_2.11-${TENSORFLOW_VERSION}.jar" \
    && echo "${TENSORFLOW_SPARK_JAR_SHA256}" "spark-tensorflow-connector_2.11-${TENSORFLOW_VERSION}.jar" | sha256sum -c - \
    && cd /tmp \
    && curl --retry 3 -fsSL -O "${TENSORFLOW_URL}/libtensorflow/libtensorflow_jni-${TENSORFLOW_VARIANT}-linux-x86_64-${TENSORFLOW_VERSION}.tar.gz" \
    && echo "${TENSORFLOW_JNI_SHA256}" "libtensorflow_jni-${TENSORFLOW_VARIANT}-linux-x86_64-${TENSORFLOW_VERSION}.tar.gz" | sha256sum -c - \
    && tar xf "libtensorflow_jni-${TENSORFLOW_VARIANT}-linux-x86_64-${TENSORFLOW_VERSION}.tar.gz" "./libtensorflow_jni.so" \
    && mv "libtensorflow_jni.so" "/usr/lib" \
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
    && ${CONDA_DIR}/bin/conda update --json --all -yq \
    && ${CONDA_DIR}/bin/conda config --system --prepend channels conda-forge \
    && ${CONDA_DIR}/bin/conda config --system --set auto_update_conda false \
    && ${CONDA_DIR}/bin/conda config --system --set show_channel_urls true \
    && ${CONDA_DIR}/bin/pip install --upgrade pip \
    && ${CONDA_DIR}/bin/conda env update --json -q -f "${CONDA_DIR}/${CONDA_ENV_YML}" \
    && ${CONDA_DIR}/bin/pip install --upgrade pip \
    && ${CONDA_DIR}/bin/conda remove --force --json -yq openjdk pyqt qt \
    && rm -rf "${HOME}/.cache/pip" "${HOME}/.cache/yarn" "${HOME}/.node-gyp" \
    && ${CONDA_DIR}/bin/conda clean --json -tipsy \
    && rm -rf /tmp/*

COPY profile "/root/.profile"
COPY bash_profile "/root/.bash_profile"
COPY bashrc "/root/.bashrc"
COPY dircolors "/root/.dircolors"

RUN cp "${MESOSPHERE_PREFIX}/libmesos-bundle/lib/libcurl.so.4" /usr/lib/x86_64-linux-gnu/libcurl.so.4.4.0

ENV SPARK_DIST_CLASSPATH="${HADOOP_HDFS_HOME}/etc/hadoop:${HADOOP_HDFS_HOME}/share/hadoop/common/lib/*:${HADOOP_HDFS_HOME}/share/hadoop/common/*:${HADOOP_HDFS_HOME}/share/hadoop/hdfs:${HADOOP_HDFS_HOME}/share/hadoop/hdfs/lib/*:${HADOOP_HDFS_HOME}/share/hadoop/hdfs/*:${HADOOP_HDFS_HOME}/share/hadoop/yarn:${HADOOP_HDFS_HOME}/share/hadoop/yarn/lib/*:${HADOOP_HDFS_HOME}/share/hadoop/yarn/*:${HADOOP_HDFS_HOME}/share/hadoop/mapreduce/lib/*:${HADOOP_HDFS_HOME}/share/hadoop/mapreduce/*:${HADOOP_HDFS_HOME}/share/hadoop/tools/lib/*" \
    HADOOP_CLASSPATH="${HADOOP_CLASSPATH}:${HADOOP_HDFS_HOME}/share/hadoop/tools/lib/*" \
    PYTHONPATH="${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-0.10.4-src.zip:${PYTHONPATH}" \
    LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu:${MESOSPHERE_PREFIX}/libmesos-bundle/lib:${JAVA_HOME}/jre/lib/amd64/server"

WORKDIR "${SPARK_HOME}"

COPY runit/service /var/lib/runit/service
COPY runit/init.sh /sbin/init.sh
COPY nginx /etc/nginx
COPY krb5.conf.mustache /etc/
COPY hadoop-env.sh "${HADOOP_HDFS_HOME}/etc/hadoop/"
COPY hadooprc "${HOME}/.hadooprc"
COPY conf/ "${SPARK_HOME}/conf/"

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

# Patch TensorFlowOnSpark to handle all Hadoop 3.x supported Filesystem URIs
COPY TFNode.py "${CONDA_DIR}/lib/python3.6/site-packages/tensorflowonspark/"
