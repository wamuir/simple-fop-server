FROM maven:3-openjdk-15

# RUN apt-get update && apt-get install -y maven xvfb

WORKDIR /srv/simple-fop-server

COPY . .

RUN install -d -m 0755 -o 1000 -g 1000 /srv/simple-fop-server/?
RUN install -d -m 0755 -o 1000 -g 1000 /srv/simple-fop-server/target

USER 1000:1000

RUN mvn package

FROM openjdk:15-slim-buster

COPY --from=0 /srv/simple-fop-server/target/simple-fop-server-0.0.1-SNAPSHOT-jar-with-dependencies.jar /bin/fop.jar

ENTRYPOINT ["java", "-Xmx256M", "-jar", "/bin/fop.jar"]

EXPOSE 8080/tcp
