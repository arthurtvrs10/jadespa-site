FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /workspace
COPY backend/pom.xml backend/pom.xml
COPY backend/src backend/src
COPY frontend frontend
RUN mvn -B -ntp -f backend/pom.xml -DskipTests package

FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
RUN groupadd --system jade && useradd --system --gid jade --home-dir /app jade
COPY --from=build --chown=jade:jade /workspace/backend/target/jade-spa-admin-0.0.1-SNAPSHOT.jar app.jar
USER jade
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
