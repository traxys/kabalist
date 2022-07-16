FROM rust:1.61 as builder

RUN cargo install trunk

WORKDIR /build
COPY Cargo.lock Cargo.toml ./
ADD types types
ADD api api
ADD client client
ADD web web
ADD cli cli
ADD admin admin

RUN cargo build --release --bin kabalist_api
RUN rustup target add wasm32-unknown-unknown
RUN cd web && trunk build --release

RUN ls

FROM debian:bullseye

WORKDIR /kabalist
COPY --from=builder /build/target/release/kabalist_api .
COPY --from=builder /build/web/dist dist
COPY --from=builder /build/api/public public

ENV KABALIST_JWT_SECRET=dmVyeSBzZWN1cmUga2V5Cg==
ENV KABALIST_EXP=10000000000
ENV KABALIST_FRONTEND=dist
ENV KABALIST_LISTEN_ADDR=0.0.0.0

ENTRYPOINT ["./kabalist_api"]

EXPOSE 8080
