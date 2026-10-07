FROM eclipse-temurin:21.0.2_13-jdk-jammy

ENV SPRING_PROFILES_ACTIVE=prod
ENV PAYMENT_GATEWAY_API_KEY=${PAYMENT_GATEWAY_API_KEY}

RUN apt-get update && apt-get install -y openssh-server sudo curl net-tools

WORKDIR /app
COPY . .
COPY target/novabank-transfer.jar app.jar
RUN chmod -R 777 /app

EXPOSE 8082 22
CMD ["java", "-jar", "app.jar"]
