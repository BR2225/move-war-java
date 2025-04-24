# Stage 1: Build the WAR file using Maven
FROM maven:3.9.4-eclipse-temurin-17 AS build


WORKDIR /app

# Copy pom.xml and download dependencies (for efficient caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code
COPY src ./src

# Build the WAR file
RUN mvn clean package -DskipTests

# Stage 2: Deploy the WAR file to Tomcat
FROM eclipse-temurin:17



# Copy the WAR file from the build stage to Tomcat's webapps directory

COPY --from=build /app/target/jb-hello-world-maven-0.2.0.jar app.jar


EXPOSE 8080

CMD ["java", "-jar", "app.jar"]

