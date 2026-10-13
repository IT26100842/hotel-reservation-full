# Stage 1: Build the Spring Boot application using Maven and OpenJDK 25
FROM maven:3.9-eclipse-temurin-25 AS builder
WORKDIR /app

# Dependency cache එක ප්‍රයෝජනයට ගැනීමට pom.xml මුලින් copy කරමු
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Source code එක copy කර JAR එක build කරමු (Tests skip කරයි)
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Minimal runtime image for Java 25
FROM eclipse-temurin:25-jre-alpine
WORKDIR /app

# Build stage එකෙන් හැදුනු JAR එක copy කරගැනීම
COPY --from=builder /app/target/*.jar app.jar

# Spring Boot default port එක
EXPOSE 8080

# Application එක run කිරීම
ENTRYPOINT ["java", "-jar", "app.jar"]