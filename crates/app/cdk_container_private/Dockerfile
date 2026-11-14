
# -------------------------------------------------------------------------
FROM public.ecr.aws/lambda/provided:al2 as builder
ARG RUST_VER=1.81.0
RUN yum group install -y "Development Tools"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup install "${RUST_VER}"


WORKDIR /app
COPY . .

# ENV RUSTFLAGS="-C target-feature=+crt-static"
WORKDIR /app/crates/app
RUN cargo build --features=glibc,private

# -------------------------------------------------------------------------
FROM public.ecr.aws/lambda/provided:al2


COPY --from=builder /app/target/debug/app ${LAMBDA_RUNTIME_DIR}/bootstrap


WORKDIR ${LAMBDA_TASK_ROOT}

CMD ["bootstrap"]
