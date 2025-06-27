# Stage 1: Build the application using Maven
FROM maven:3.9.4-eclipse-temurin-17-alpine as build

WORKDIR /app

COPY pom.xml .
RUN mvn -B dependency:go-offline dependency:resolve-plugins

COPY src ./src
RUN mvn -B package -DskipTests

# Stage 2: Create minimal runtime image
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
