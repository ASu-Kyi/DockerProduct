## Build argument for Java version
#ARG JAVA_VERSION=21
#
## Stage 1: Build the application
#FROM maven:3.9.12 AS builder
#WORKDIR /app
#COPY pom.xml .
#COPY src ./src
#RUN mvn clean package
#
## Stage 2: Run the application
#FROM eclipse-temurin:23-jre
#WORKDIR /app
#COPY --from=builder /app/target/dockerpro-service.jar app.jar
#EXPOSE 8080
#ENTRYPOINT ["java", "-jar", "app.jar"]
# ---------- Stage 1: Build ----------
FROM maven:3.9.9-eclipse-temurin-23 AS builder
WORKDIR /app

COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src

# IMPORTANT: skip tests (no DB during build)
RUN mvn -B clean package

# ---------- Stage 2: Run ----------
FROM eclipse-temurin:23-jre
WORKDIR /app

COPY --from=builder /app/target/dockerpro-service.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
