FROM golang:1.16

WORKDIR /go/src/app
COPY app.go .

RUN go build app.go

EXPOSE 8080

CMD ["./app"]