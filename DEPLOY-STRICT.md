```bash
dcos security org service-accounts keypair dispatcher-private-key.pem dispatcher-public-key.pem

dcos security org service-accounts create -p dispatcher-public-key.pem -d "Dev Spark Service Account" dev_spark_dispatcher
dcos security org service-accounts show

dcos security secrets create-sa-secret --strict dispatcher-private-key.pem dev_spark_dispatcher dev/spark/dispatcher/serviceCredential
dcos security secrets list /dev/spark

dcos security org users grant dev_spark_dispatcher dcos:mesos:master:task:user:nobody create --description "Allow dev_spark_dispatcher to launch tasks under the Linux user: nobody"
dcos security org users grant dev_spark_dispatcher dcos:mesos:master:framework:role:dev-spark-dispatcher create --description "Allow dev_spark_dispatcher to register with Mesos and consume resources from the dev-spark-dispatcher role"
dcos security org users grant dev_spark_dispatcher dcos:mesos:master:framework:role:dev-spark-executor create --description "Allow dev_spark_dispatcher to register with Mesos and consume resources from the dev-spark-executor role"
dcos security org users grant dev_spark_dispatcher dcos:mesos:master:task:app_id:/dev/spark create --description "Allow dev_spark_dispatcher to create tasks under the /dev/spark namespace"

tee dev-spark-dispatcher-quota.json <<- 'EOF'
{
 "role": "dev-spark-dispatcher",
 "guarantee": [
   {
     "name": "cpus",
     "type": "SCALAR",
     "scalar": { "value": 2.0 }
   },
   {
     "name": "mem",
     "type": "SCALAR",
     "scalar": { "value": 2048.0 }
   }
 ]
}
EOF

tee dev-spark-executor-quota.json <<- 'EOF'
{
 "role": "dev-spark-executor",
 "guarantee": [
   {
     "name": "cpus",
     "type": "SCALAR",
     "scalar": { "value": 4.0 }
   },
   {
     "name": "mem",
     "type": "SCALAR",
     "scalar": { "value": 4096.0 }
   }
 ]
}
EOF

curl --cacert dcos-ca.crt -fsSL -X POST -H "Authorization: token=$(dcos config show core.dcos_acs_token)" -H "Content-Type: application/json" $(dcos config show core.dcos_url)/mesos/quota -d @dev-spark-dispatcher-quota.json

curl --cacert dcos-ca.crt -fsSL -X POST -H "Authorization: token=$(dcos config show core.dcos_acs_token)" -H "Content-Type: application/json" $(dcos config show core.dcos_url)/mesos/quota -d @dev-spark-executor-quota.json

dcos marathon app add spark-dispatcher-ucr.json
dcos marathon app add spark-history-s3-ucr.json

dcos spark run --verbose --name=/dev/spark/dispatcher --submit-args=" \
--conf spark.mesos.principal=dev_spark_dispatcher \
--conf spark.mesos.role=dev-spark-executor \
--conf spark.mesos.containerizer=mesos \
--class org.apache.spark.examples.SparkPi http://downloads.mesosphere.com/spark/assets/spark-examples_2.11-2.0.1.jar 100"

dcos spark run --verbose --name=/dev/spark/dispatcher --submit-args=" \
--conf spark.mesos.principal=dev_spark_dispatcher \
--conf spark.mesos.role=dev-spark-executor \
--conf spark.mesos.containerizer=mesos \
--conf spark.mesos.driverEnv.SPARK_MESOS_KRB5_CONF_BASE64=dmlzaG51Cg== \
--conf spark.executorEnv.SPARK_MESOS_KRB5_CONF_BASE64=dmlzaG51Cg== \
--conf spark.mesos.driver.secret.values=dmlzaG51Cg==,dmlzaG51Cg== \
--conf spark.mesos.driver.secret.filenames="calvin-user-1-keytab.base64,calvin-user-2-keytab.base64" \
--conf spark.mesos.executor.secret.values=dmlzaG51Cg==,dmlzaG51Cg== \
--conf spark.mesos.executor.secret.filenames=calvin-user-1-keytab.base64,calvin-user-2-keytab.base64 \
--class org.apache.spark.examples.SparkPi http://downloads.mesosphere.com/spark/assets/spark-examples_2.11-2.0.1.jar 100"

dcos spark run --verbose --name=/dev/spark/dispatcher --submit-args=" \
--conf spark.mesos.principal=dev_spark_dispatcher \
--conf spark.mesos.role=dev-spark-executor \
--conf spark.mesos.containerizer=mesos \
--conf spark.mesos.driverEnv.SPARK_MESOS_KRB5_CONF_BASE64=dmlzaG51Cg== \
--conf spark.executorEnv.SPARK_MESOS_KRB5_CONF_BASE64=dmlzaG51Cg== \
--conf spark.mesos.driver.labels=DCOS_SPACE:/dev/spark \
--conf spark.mesos.task.labels=DCOS_SPACE:/dev/spark \
--conf spark.mesos.driver.secret.names=/dev/spark/AWS_ACCESS_KEY_ID,/dev/spark/AWS_SECRET_ACCESS_KEY \
--conf spark.mesos.driver.secret.envkeys=AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY \
--conf spark.eventLog.enabled=true \
--conf spark.eventLog.dir=s3a://vishnu-mohan/spark/history \
--class org.apache.spark.examples.SparkPi http://downloads.mesosphere.com/spark/assets/spark-examples_2.11-2.0.1.jar 100"

DO NOT RUN:
dcos spark run --verbose --name=/dev/spark/dispatcher --submit-args=" \
--conf spark.mesos.principal=dev_spark_dispatcher \
--conf spark.mesos.role=dev-spark-executor \
--conf spark.mesos.containerizer=mesos \
--conf spark.mesos.driverEnv.SPARK_MESOS_KRB5_CONF_BASE64=dmlzaG51Cg== \
--conf spark.executorEnv.SPARK_MESOS_KRB5_CONF_BASE64=dmlzaG51Cg== \
--conf spark.mesos.driver.labels=DCOS_SPACE:/dev/spark \
--conf spark.mesos.task.labels=DCOS_SPACE:/dev/spark \
--conf spark.mesos.driver.secret.names=/dev/spark/AWS_ACCESS_KEY_ID,/dev/spark/AWS_SECRET_ACCESS_KEY \
--conf spark.mesos.driver.secret.envkeys=AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY \
--conf spark.mesos.driver.secret.values=dmlzaG51Cg==,dmlzaG51Cg== \
--conf spark.mesos.driver.secret.filenames="calvin-user-1-keytab.base64,calvin-user-2-keytab.base64" \
--conf spark.mesos.executor.secret.values=dmlzaG51Cg==,dmlzaG51Cg== \
--conf spark.mesos.executor.secret.filenames=calvin-user-1-keytab.base64,calvin-user-2-keytab.base64 \
--conf spark.eventLog.enabled=true \
--conf spark.eventLog.dir=s3a://vishnu-mohan/spark/history \
--class org.apache.spark.examples.SparkPi http://downloads.mesosphere.com/spark/assets/spark-examples_2.11-2.0.1.jar 100"

```
