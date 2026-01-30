# ────────────────────────────────────────────────
# Stage 1: build
# ────────────────────────────────────────────────
FROM golang:1.25-alpine AS build_base
WORKDIR /tmp_build

COPY . .

RUN go mod download
RUN go install github.com/a-h/templ/cmd/templ@latest 


RUN templ generate
RUN GOOS=linux CGO_ENABLED=0 GOARCH=amd64 go build -o bootstrap .


RUN apk add --update nodejs npm
RUN npm install tailwindcss @tailwindcss/cli
RUN npx @tailwindcss/cli -i ./static/input.css -o ./static/output.css --minify

# ────────────────────────────────────────────────
# Stage 2: runtime (ensures container is very small)
# ────────────────────────────────────────────────
FROM alpine:3.23.3 
RUN apk add ca-certificates

COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.9.1 /lambda-adapter /opt/extensions/lambda-adapter
COPY --from=build_base /tmp_build/bootstrap ./bootstrap


COPY --from=build_base /tmp_build/static/htmx.min.js ./static/htmx.min.js
COPY --from=build_base /tmp_build/static/output.css ./static/output.css
COPY /static/favicon.ico ./static/favicon.ico

ENV ENV_IS_PROD=true VERSION=0.1 PORT=8080
EXPOSE $PORT


CMD ["./bootstrap"]
