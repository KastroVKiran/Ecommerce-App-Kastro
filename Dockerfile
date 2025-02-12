# Use Eclipse Temurin as the base image for Java 17 with Maven
FROM eclipse-temurin:17-jdk AS builder

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the pom.xml and source code to the container
COPY pom.xml ./
COPY src ./src

# Build the project
RUN mvn clean package -DskipTests

# Use a clean image for the final container (without unnecessary build tools)
FROM eclipse-temurin:17-jdk

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the compiled JAR file from the builder stage
COPY --from=builder /usr/src/app/target/*.jar /usr/src/app/

# Expose the port your app is running on
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "/usr/src/app/*.jar"]
