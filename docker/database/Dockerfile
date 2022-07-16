FROM rust:1.61 as builder

RUN cargo install sqlx-cli

WORKDIR /build
COPY Cargo.lock Cargo.toml ./
ADD types types
ADD api api
ADD client client
ADD web web
ADD cli cli
ADD admin admin

RUN cargo build --release --bin kb_admin

FROM postgres:14.4

COPY --from=builder /usr/local/cargo/bin/sqlx /usr/local/bin
COPY --from=builder /build/target/release/kb_admin /usr/local/bin

ADD api/sqlx /sqlx
COPY docker/database/init-kabalist.sh .

RUN echo "#!/usr/bin/env bash" > /docker-entrypoint-initdb.d/init.sh \
	&& echo "$(realpath init-kabalist.sh) /sqlx" > /docker-entrypoint-initdb.d/init.sh
