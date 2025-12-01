#!/bin/bash

# 1. Dừng Tomcat Homebrew service
echo "Stopping Tomcat..."
brew services stop tomcat

# 2. Xóa webapp cũ
echo "Removing old webapp..."
rm -rf /opt/homebrew/Cellar/tomcat/11.0.13/libexec/webapps/StudentManagement-1.0-SNAPSHOT
rm -f /opt/homebrew/Cellar/tomcat/11.0.13/libexec/webapps/StudentManagement-1.0-SNAPSHOT.war

# 3. Build project bằng Maven
echo "Building project..."
mvn clean package

# 4. Copy WAR mới vào webapps
echo "Deploying WAR..."
cp target/StudentManagement-1.0-SNAPSHOT.war /opt/homebrew/Cellar/tomcat/11.0.13/libexec/webapps/

# 5. Start Tomcat Homebrew service
echo "Starting Tomcat..."
brew services start tomcat

echo "Deployment finished. Check catalina.out for logs:"
echo "tail -f /opt/homebrew/Cellar/tomcat/11.0.13/libexec/logs/catalina.out"

