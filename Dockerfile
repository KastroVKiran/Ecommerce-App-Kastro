# Use Eclipse Temurin as the base image for Java 17
FROM eclipse-temurin:17-jdk as builder

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the pom.xml and source code to the container
COPY pom.xml ./
COPY src ./src

# Install Maven and build the project
RUN apt-get update && apt-get install -y maven
RUN mvn clean package -DskipTests

# Use a clean image for the final container
FROM eclipse-temurin:17-jdk

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the compiled JAR file from the builder stage
COPY --from=builder /usr/src/app/target/*.jar /usr/src/app/app.jar

# Expose the port the app will run on
EXPOSE 8080

# Set the command to run the app
CMD ["java", "-jar", "app.jar"]
