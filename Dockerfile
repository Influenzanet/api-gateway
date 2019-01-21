FROM phev8/go-dep-builder:latest as builder
RUN mkdir -p /go/src/github.com/influenzanet/api-gateway/
ADD . /go/src/github.com/influenzanet/api-gateway/
WORKDIR /go/src/github.com/influenzanet/api-gateway
RUN dep ensure
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o api-gateway .
FROM scratch
COPY --from=builder /go/src/github.com/influenzanet/api-gateway/api-gateway /app/
COPY ./config.yaml /app/
WORKDIR /app
EXPOSE 3100:3100
CMD ["./api-gateway"]
