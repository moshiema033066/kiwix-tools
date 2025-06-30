FROM ubuntu:22.04

# Install build and runtime dependencies
RUN apt-get update && apt-get install -y \
    dirmngr gnupg ca-certificates curl \
    && mkdir -p /etc/apt/keyrings \
    # Import the Kiwix team signing key (avoids deprecated apt-key)
    && curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x012AEA4FFD0486EA2F22C80C91262FF81F6F5758" | gpg --dearmor -o /etc/apt/keyrings/kiwix.gpg \
    # Add the Kiwix stable PPA for Jammy (22.04)
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/kiwix.gpg] http://ppa.launchpad.net/kiwixteam/release/ubuntu jammy main" > /etc/apt/sources.list.d/kiwix.list \
    && apt-get update && apt-get install -y \
    build-essential meson ninja-build git \
    libicu-dev libcurl4-openssl-dev libsqlite3-dev \
    libmagic-dev zlib1g-dev libbz2-dev liblzma-dev \
    libzim-dev libkiwix-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy kiwix-tools source code
COPY kiwix-tools /kiwix-tools

# Set working directory
WORKDIR /kiwix-tools

# Build kiwix-serve and install it
RUN meson setup build --buildtype=release && \
    ninja -C build kiwix-serve && \
    cp build/kiwix-serve /usr/local/bin/ && \
    rm -rf /kiwix-tools

# Default command
ENTRYPOINT ["kiwix-serve"]

COPY make-library.sh /make-library.sh
RUN ls -l /make-library.sh 

COPY test.txt /test.txt
RUN ls -l /test.txt 