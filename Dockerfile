# -------- Stage 1: Build --------
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# -------- Stage 2: Run --------
FROM tomcat:9.0-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=builder /app/target/EcommerceApp.war \
     /usr/local/tomcat/webapps/EcommerceApp.war

EXPOSE 8080
CMD ["catalina.sh", "run"]

