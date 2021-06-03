FROM maven:3-openjdk-15

WORKDIR /build

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src/ /build/src/
RUN mvn package


FROM openjdk:15-jdk-oraclelinux8

RUN install -d -m 0755 -o 1000 -g 1000 /app
WORKDIR /app
COPY --from=0 /build/target/simple-fop-server-0.0.1-SNAPSHOT-jar-with-dependencies.jar simple-fop-server.jar

COPY conf/fop.xconf /usr/local/etc/fop.xconf

USER 1000:1000

ENTRYPOINT ["java", "-jar", "/app/simple-fop-server.jar"]

EXPOSE 8080/tcp
