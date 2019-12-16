FROM golang:1.11-alpine as build

WORKDIR /build

ADD . /build

RUN apk --no-cache add git
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-s" -a -installsuffix cgo ganalytics.go

FROM alpine:3.5
LABEL description="Obtains Google Analytics RealTime API metrics, and presents them to prometheus for scraping."

RUN apk add --update ca-certificates
ENV APP_PATH /ga
RUN mkdir $APP_PATH
COPY --from=build /build/ganalytics $APP_PATH/

WORKDIR $APP_PATH
ENTRYPOINT $APP_PATH"/ganalytics"
