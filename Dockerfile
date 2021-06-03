FROM maven:3-openjdk-16 as build

WORKDIR /build

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src/ /build/src/
RUN mvn package

# build minimal alpine JDK with just the modules we need:
# java.base: minimal java APIs
# java.desktop: (bogusly) required by FOP since it uses its Rectangle2D...
# java.xml: required by FOP
# jdk.httpserver: used to spin up httpserver
FROM openjdk:16-jdk-alpine as jdkbuild
RUN ["jlink", "--compress=2", \
     "--module-path", "/opt/jdk/jdk-16/jmods", \
     "--add-modules", "java.base", \
     "--add-modules", "java.desktop", \
     "--add-modules", "java.xml", \
     "--add-modules", "jdk.httpserver", \
     "--output", "/jlinked"]

FROM alpine:latest
RUN apk add --no-cache freetype ttf-dejavu
RUN install -d -m 0755 -o 1000 -g 1000 /app
WORKDIR /app
COPY --from=build /build/target/simple-fop-server-0.0.1-SNAPSHOT-jar-with-dependencies.jar simple-fop-server.jar
COPY --from=jdkbuild /jlinked /opt/jdk
COPY conf/fop.xconf /usr/local/etc/fop.xconf

USER 1000:1000

ENTRYPOINT ["/opt/jdk/bin/java", "-jar", "/app/simple-fop-server.jar"]

EXPOSE 8080/tcp
