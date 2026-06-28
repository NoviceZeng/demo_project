FROM harbor.fusionride.com/library/openjdk:8

LABEL maintainer="novice"

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' >/etc/timezone

WORKDIR /app

COPY target/*.jar app.jar

EXPOSE 9007

CMD ["java", "-jar", "app.jar"]