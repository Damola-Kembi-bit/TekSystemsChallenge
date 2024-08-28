FROM openjdk8:alpine-slim
WORKDIR /DevSec
COPY . /DevSec
RUN addgroup -S devsec && adduser -S damolak -G devsec
EXPOSE 8080
USER damolak
ENTRYPOINT ["java"]
