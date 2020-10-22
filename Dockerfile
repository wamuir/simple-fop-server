FROM maven:3-openjdk-15

COPY conf/fop.xconf /usr/local/etc/fop.xconf

RUN install -d -m 0755 -o 1000 -g 1000 /build

WORKDIR /build

USER 1000:1000

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src/ /build/src/

RUN mvn package

ENTRYPOINT ["java", "-jar", "target/simple-fop-server-0.0.1-SNAPSHOT-jar-with-dependencies.jar"]

EXPOSE 8080/tcp
