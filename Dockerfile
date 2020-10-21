FROM golang AS build
WORKDIR /code
COPY . /code
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build \
    -ldflags "-X github.com/tomcz/openldap_exporter.commit=$(git rev-parse --short HEAD 2>/dev/null) -X github.com/tomcz/openldap_exporter.tag=$(git describe --tags 2>/dev/null)" \
    -o target/openldap_exporter \
    ./cmd/openldap_exporter

FROM scratch
WORKDIR /app
COPY --from=build /code/target/openldap_exporter /app/openldap_exporter
ENTRYPOINT [ "/app/openldap_exporter" ]
