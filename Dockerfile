FROM maven:3-openjdk-16 AS srv-builder

WORKDIR /build

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src src
RUN mvn package


# build minimal JDK with just the modules we need:
# java.base: minimal java APIs
# java.desktop: (bogusly) required by FOP since it uses its Rectangle2D...
# java.xml: required by FOP
# jdk.httpserver: used to spin up httpserver
FROM openjdk:16-jdk-slim-buster AS jdk-builder

RUN ["jlink", "--compress=2", \
     "--module-path", "/opt/jdk/jdk-16/jmods", \
     "--add-modules", "java.base", \
     "--add-modules", "java.desktop", \
     "--add-modules", "java.xml", \
     "--add-modules", "jdk.httpserver", \
     "--output", "/jlinked"]


FROM debian:buster-slim

RUN apt-get update && apt-get -y install --no-install-recommends \
    fontconfig \
    && rm -rf /var/lib/apt/lists/*

RUN install -d -m 0755 -o 1000 -g 1000 /app
COPY --from=srv-builder /build/target/simple-fop-server-0.1.2-jar-with-dependencies.jar /app/simple-fop-server.jar
COPY --from=jdk-builder /jlinked /opt/jdk
COPY conf/fop.xconf /usr/local/etc/fop.xconf

USER 1000:1000

WORKDIR /app

ENTRYPOINT ["/opt/jdk/bin/java", "-jar", "simple-fop-server.jar"]

EXPOSE 8080/tcp
