# Workflow trigger: visible change
# --------  base image ------------
    FROM ubuntu:22.04

    # --------  A. add Kiwix PPA that contains libzim-9 ------------
    RUN apt-get update && \
        # tools needed for secure key retrieval
        apt-get install -y --no-install-recommends curl gnupg dirmngr ca-certificates && \
        mkdir -p /etc/apt/keyrings && \
        # Import the Kiwix team key (fingerprint 012AEA4FFD0486EA2F22C80C91262FF81F6F5758)
        curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x012AEA4FFD0486EA2F22C80C91262FF81F6F5758" | \
          gpg --dearmor -o /etc/apt/keyrings/kiwix-archive.gpg && \
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/kiwix-archive.gpg] http://ppa.launchpad.net/kiwixteam/release/ubuntu jammy main" \
          > /etc/apt/sources.list.d/kiwix.list
    
    # --------  B. build-time dependencies ------------
    RUN apt-get update && apt-get install -y \
          meson ninja-build gcc g++ pkg-config \
          libzim-dev libkiwix-dev \
          zlib1g-dev libbz2-dev liblzma-dev \
          libicu-dev libcurl4-gnutls-dev libsqlite3-dev libmagic-dev \
          libdocopt-dev \
          ca-certificates git && \
        # -------------------------------------------------------------------
        # The Ubuntu libdocopt-dev package does _not_ ship a docopt.pc file.
        # Meson relies on pkg-config to locate the library, so we create a
        # minimal one manually.  This is sufficient for the build to proceed.
        # -------------------------------------------------------------------
        DOCOPT_PCDIR="/usr/lib/$(dpkg-architecture -qDEB_HOST_MULTIARCH)/pkgconfig" && \
        mkdir -p "$DOCOPT_PCDIR" && \
        printf "prefix=/usr\nexec_prefix=\${prefix}\nlibdir=\${exec_prefix}/lib/$(dpkg-architecture -qDEB_HOST_MULTIARCH)\nincludedir=\${prefix}/include\n\nName: docopt\nDescription: C++11 port of docopt\nVersion: 0.6.3\nLibs: -L\${libdir} -ldocopt\nCflags: -I\${includedir}\n" > "$DOCOPT_PCDIR/docopt.pc" && \
        chmod 644 "$DOCOPT_PCDIR/docopt.pc" && \
        rm -rf /var/lib/apt/lists/*
    
    # --------  C. copy kiwix-tools source & build ------------
    COPY kiwix-tools/README.md /kiwix-tools/README.md
    WORKDIR /kiwix-tools
    
    RUN meson setup build --buildtype=release && \
        ninja -C build && \
        cp build/src/server/kiwix-serve /usr/local/bin/ && \
        cp build/src/manager/kiwix-manage /usr/local/bin/ && \
        rm -rf /kiwix-tools
    
    # --------  D. entrypoint ------------
    ENTRYPOINT ["kiwix-serve"]
    
    # --------  E. copy make-library.sh script ------------
    COPY kiwix-offline-hub/make-library.sh /usr/local/bin/make-library.sh
    RUN ls -l /usr/local/bin/ || true

    COPY ./kiwix-offline-hub/make-library.sh /usr/local/bin/make-library.sh
    RUN ls -l /usr/local/bin/ || true

    COPY kiwix-offline-hub/make-library.sh .
    RUN ls -l /make-library.sh || true

    COPY ./kiwix-offline-hub/make-library.sh .
    RUN ls -l /make-library.sh || true

    COPY kiwix-offline-hub/make-library.sh /make-library.sh
    RUN ls -l /make-library.sh || true
    
# Trigger workflow: dummy change

# Force cache miss: $(Get-Date)



