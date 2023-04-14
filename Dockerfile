FROM amazoncorretto:11-alpine-jdk
COPY target/*jar *.jar
CMD java -jar *.jar
