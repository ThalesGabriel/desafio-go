FROM golang:1.16 AS builder

WORKDIR /go/src

COPY go.mod .

### Setting a proxy for downloading modules
ENV GOPROXY https://proxy.golang.org,direct

### Download Go application module dependencies
RUN go mod download

COPY . .

### CGO has to be disabled cross platform builds
### Otherwise the application won't be able to start
ENV CGO_ENABLED=0

### Build the Go app for a linux OS
RUN GOOS=linux go build ./main.go

##### MULTI STAGE BUILDING partindo do zero absoluto #####
FROM scratch

### Set working directory
WORKDIR /app

### Copy built binary application from 'builder' image
COPY --from=builder /go/src .

### Run the binary application
ENTRYPOINT ["/app/main"]