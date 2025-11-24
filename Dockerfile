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

# Use Maven + JDK 17 image for build
FROM maven:3.9.3-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml and source code
COPY DevOps-Project-33/DevSecOps-CI-CD-Pipeline /app

# Skip license plugin and tests during build
RUN mvn clean install -DskipTests -Dlicense.skip=true

# -------------------------------
# Stage 2: Build lightweight runtime image
# -------------------------------
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy WAR from build stage
COPY --from=build /app/target/jpetstore.war /app/jpetstore.war

# Expose default Tomcat port
EXPOSE 8080

# Run WAR using embedded Tomcat (simplest way)
RUN apk add --no-cache bash curl

# Command to run WAR using Tomcat
# You can replace with your preferred servlet container
CMD ["sh", "-c", "echo 'Deploy WAR manually or run in your preferred container'"]
