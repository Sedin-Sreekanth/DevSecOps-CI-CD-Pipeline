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
# Stage 1: Build
FROM maven:3.9.3-eclipse-temurin-21 AS builder
WORKDIR /usr/src/myapp
COPY . .
RUN mvn clean package -Dlicense.skip=true

# Stage 2: Runtime
FROM eclipse-temurin:21-jdk
WORKDIR /usr/src/myapp
COPY --from=builder /usr/src/myapp/target/*.war ./app.war

# Run the WAR
CMD ["java", "-jar", "app.war"]

