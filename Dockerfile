FROM swift:5.9-focal as build

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

COPY ./Package.* ./
RUN swift package resolve

COPY . .
RUN swift build -c release

WORKDIR /staging

RUN cp "$(swift build --package-path /build -c release --show-bin-path)/Run" ./

RUN [ -d /build/Public ] && { mv /build/Public ./Public && chmod -R a-w ./Public; } || true
RUN [ -d /build/Resources ] && { mv /build/Resources ./Resources && chmod -R a-w ./Resources; } || true

FROM swift:5.9-focal-slim

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && \
    apt-get -q update && apt-get -q dist-upgrade -y && rm -r /var/lib/apt/lists/*

RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /app vapor

WORKDIR /app
COPY --from=build --chown=vapor:vapor /staging /app

USER vapor:vapor
EXPOSE $PORT

ENTRYPOINT ["./Run"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0"]
