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

# Use Maven + JDK 17 image
FROM maven:3.9.2-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml and download dependencies first (cache)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code
COPY . .

# Build the project (skip tests and license plugin)
RUN mvn clean install -DskipTests=true -Dlicense.skip=true

# Use a smaller JDK image for running the WAR
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy the WAR from the build stage
COPY --from=build /app/target/jpetstore.war .

# Expose default Tomcat port
EXPOSE 8080

# Command to run WAR in embedded Tomcat (or configure as needed)
# If using standalone Tomcat in Docker, adjust this CMD
CMD ["java", "-jar", "jpetstore.war"]
