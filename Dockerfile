FROM golang:1.25.1-alpine AS builder

WORKDIR /app

RUN apk add --no-cache git

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o easytrips-server ./cmd/server

FROM alpine:3.20

WORKDIR /app

RUN apk add --no-cache ca-certificates

COPY --from=builder /app/.env .
COPY --from=builder /app/web/ ./web
COPY --from=builder /app/easytrips-server .

EXPOSE 8080
CMD ["./easytrips-server"]