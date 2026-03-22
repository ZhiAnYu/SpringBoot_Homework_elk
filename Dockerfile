FROM eclipse-temurin:17.0.6_10-jre

EXPOSE 8080

COPY target/demoDocker-0.0.1-SNAPSHOT.jar app.jar

CMD ["java", "-jar", "app.jar"]