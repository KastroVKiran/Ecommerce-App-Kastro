# Use Maven-based image for building
FROM maven:3.8.7-eclipse-temurin-17 AS builder

# Set the working directory
WORKDIR /usr/src/app

# Copy the pom.xml and fetch dependencies
COPY pom.xml ./
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the WAR file
RUN mvn clean package -DskipTests

# Use Tomcat image for deployment
FROM tomcat:9.0

# Set working directory
WORKDIR /usr/local/tomcat/webapps/

# Copy the WAR file from the builder stage
COPY --from=builder /usr/src/app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat's default port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
