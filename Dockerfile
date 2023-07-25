# build stage
FROM golang:1.20.6-alpine3.18 AS builder
ADD . /src
RUN cd /src && go build -o jplay .

# final stage
FROM alpine:3.18

ENV PORT 8080

WORKDIR /app

COPY --from=builder /src/jplay .
COPY static static

ENTRYPOINT ["/app/jplay"]
