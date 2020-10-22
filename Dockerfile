FROM maven:3-openjdk-15

RUN install -d -m 0755 -o 1000 -g 1000 /srv/simple-fop-server
RUN ln -s /srv/simple-fop-server/conf/fop.xconf /usr/local/etc/fop.xconf

USER 1000:1000

WORKDIR /srv/simple-fop-server

COPY . .

RUN mvn package

ENTRYPOINT ["java", "-Xmx256M", "-jar", "target/simple-fop-server-0.0.1-SNAPSHOT-jar-with-dependencies.jar"]

EXPOSE 8080/tcp
