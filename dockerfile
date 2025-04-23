# Stage 1: Build the app with Maven
FROM maven:3.9.9-eclipse-temurin-17 AS build

# Set working directory inside the container
WORKDIR /app

# Copy everything to /app
COPY . .

# Build the project and create the shaded JAR
RUN mvn clean package

# Stage 2: Create a minimal runtime image
FROM eclipse-temurin:17

# Set working directory
WORKDIR /app

# Copy the fat jar from the build stage
COPY --from=build /app/target/jb-hello-world-maven-0.2.0.jar app.jar

# Default command
CMD ["java", "-jar", "app.jar"]
