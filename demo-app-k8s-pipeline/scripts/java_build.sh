#!/bin/bash
svc_port=$1
microsvc=$(echo "${svc_port}" | cut -d":" -f 1)
set -x

export JAVA_HOME=/opt/jdk1.8
export JRE_HOME=$JAVA_HOME/jre
#export CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
cd demo-app-code || exit
/opt/maven3.8.6/bin/mvn -pl "${microsvc}" -am clean package
