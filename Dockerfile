# Use OpenJDK 17 instead of OpenJDK 11
FROM eclipse-temurin:17-jdk

# Expose application port
EXPOSE 8080

# Define application home directory
ENV APP_HOME /usr/src/app

# Copy the compiled JAR file into the container
COPY target/*.jar $APP_HOME/app.jar

# Set the working directory
WORKDIR $APP_HOME

# Run the application
CMD ["java", "-jar", "app.jar"]
