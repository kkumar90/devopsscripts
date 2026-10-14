dnf install java-21-amazon-corretto -y
wget https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.14/bin/apache-tomcat-11.0.14.tar.gz
tar -zxvf apache-tomcat-11.0.14.tar.gz
sed -i '56  a\<role rolename="manager-gui"/>' apache-tomcat-11.0.14/conf/tomcat-users.xml
sed -i '57  a\<role rolename="manager-script"/>' apache-tomcat-11.0.14/conf/tomcat-users.xml
sed -i '58  a\<user username="tomcat" password="root123456" roles="manager-gui, manager-script"/>' apache-tomcat-11.0.14/conf/tomcat-users.xml
sed -i '59  a\</tomcat-users>' apache-tomcat-11.0.14/conf/tomcat-users.xml
sed -i '56d' apache-tomcat-11.0.14/conf/tomcat-users.xml
sed -i '21d' apache-tomcat-11.0.14/webapps/manager/META-INF/context.xml
sed -i '22d' apache-tomcat-11.0.14/webapps/manager/META-INF/context.xml
sh apache-tomcat-11.0.14/bin/startup.sh







#By Claude:

#!/bin/bash
set -e

TOMCAT_VER=11.0.27
TOMCAT_DIR=apache-tomcat-${TOMCAT_VER}

# 1. Java
dnf install -y java-21-amazon-corretto wget tar

# 2. Download and extract (archive.apache.org keeps all versions)
wget https://archive.apache.org/dist/tomcat/tomcat-11/v${TOMCAT_VER}/bin/${TOMCAT_DIR}.tar.gz
tar -zxvf ${TOMCAT_DIR}.tar.gz

# 3. Add roles and user just before the closing </tomcat-users> tag
sed -i '/<\/tomcat-users>/i \
  <role rolename="manager-gui"/>\
  <role rolename="manager-script"/>\
  <user username="tomcat" password="root123456" roles="manager-gui,manager-script"/>' \
  ${TOMCAT_DIR}/conf/tomcat-users.xml

# 4. Remove the localhost-only Valve so Manager is reachable remotely
perl -0pi -e 's/\s*<Valve className="org\.apache\.catalina\.valves\.Remote\w+Valve".*?\/>//s' \
  ${TOMCAT_DIR}/webapps/manager/META-INF/context.xml

# 5. (Optional) same for Host Manager
perl -0pi -e 's/\s*<Valve className="org\.apache\.catalina\.valves\.Remote\w+Valve".*?\/>//s' \
  ${TOMCAT_DIR}/webapps/host-manager/META-INF/context.xml

# 6. Start Tomcat
sh ${TOMCAT_DIR}/bin/startup.sh

echo "Tomcat started: http://<server-ip>:8080  |  Manager: http://<server-ip>:8080/manager/html"
