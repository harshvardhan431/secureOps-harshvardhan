# ---- Stage 1: build ----
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN mvn -q clean package -DskipTests

# ---- Stage 2: runtime ----
FROM eclipse-temurin:21-jre-alpine
RUN apk upgrade --no-cache \
 && addgroup -S app && adduser -S -G app -H -s /sbin/nologin app
WORKDIR /app
COPY --from=build --chown=app:app /build/target/*.jar app.jar
USER app
ENV SPRING_PROFILES_ACTIVE=prod
EXPOSE 8082
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
  CMD nc -z 127.0.0.1 8082 || exit 1
ENTRYPOINT ["java", "-jar", "app.jar"]
