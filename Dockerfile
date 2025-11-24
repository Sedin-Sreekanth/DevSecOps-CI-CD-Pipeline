#
#    Copyright 2010-2023 the original author or authors.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       https://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
# Use official Maven + JDK image
FROM maven:3.9.5-eclipse-temurin-21 AS build

# Set working directory
WORKDIR /usr/src/myapp

# Copy only pom.xml first to leverage Docker cache
COPY DevOps-Project-33/DevSecOps-CI-CD-Pipeline/pom.xml ./

# Copy source code
COPY DevOps-Project-33/DevSecOps-CI-CD-Pipeline/src ./src

# Build the application (skip license plugin to avoid Git-related errors)
RUN mvn clean package -DskipTests -Dlicense.skip=true

# Use a smaller JDK image to run the app
FROM eclipse-temurin:21-jdk

WORKDIR /usr/src/myapp

# Copy the built WAR/JAR from the build stage
COPY --from=build /usr/src/myapp/target /usr/src/myapp/target

# Expose port
EXPOSE 8080

# Run the app (update to your command if WAR/Tomcat needed)
CMD ["java", "-jar", "target/jpetstore.war"]
