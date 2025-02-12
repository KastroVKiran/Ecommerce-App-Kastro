# Use Maven-based image for building
FROM maven:3.8.7-eclipse-temurin-17 AS builder

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the pom.xml and download dependencies (optimizing cache usage)
COPY pom.xml ./
RUN mvn dependency:go-offline -B

# Copy the source code
COPY src ./src

# Build the project
RUN mvn clean package -DskipTests

# Use a clean JDK image for the final container
FROM eclipse-temurin:17-jdk

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the compiled JAR file from the builder stage
COPY --from=builder /usr/src/app/target/*.jar /usr/src/app/app.jar

# Expose the port your app is running on
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "/usr/src/app/app.jar"]
