# syntax=docker/dockerfile:1

# Define base image
ARG base_image=ubuntu:latest

#-------------------------------BUILDER--------------------------------
# Use the base image for building
FROM ubuntu:latest AS builder
ARG base_image

# Renew the args
ARG headless_build=1
ARG cmake_build_type=Release

# Environment settings
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV CMAKE_BUILD_TYPE=${cmake_build_type}
ENV HEADLESS_BUILD=${headless_build}

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        clang \
        clang-format \
        cmake \
        curl \
        libglut-dev \
        libopenal-dev \
        libsdl2-dev \
        libvorbis-dev \
        make \
        python3-pip \
        python3.12-dev \
        python3.12-venv \
        rsync && \
    rm -rf /var/lib/apt/lists/*

# Copy source code
COPY ./ /ballistica

# Set the working directory
WORKDIR /ballistica

# Compile the application
RUN mkdir /ballistica_cmake && \
    if [ "$HEADLESS_BUILD" != "0" ]; then \
        make cmake-server-build && \
        mv build/cmake/*/ballisticakit_headless build/cmake/*/staged/dist; \
    else \
        make cmake-build && \
        mv build/cmake/*/ballisticakit build/cmake/*/staged/; \
    fi && \
    mv build/cmake/*/staged/* /ballistica_cmake

#-------------------------------RUNNER--------------------------------
# Use a fresh Ubuntu image for running the compiled application
FROM ubuntu:latest AS runner
ARG base_image

# Environment settings
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Renew the args
ARG headless_build=1
ARG cmake_build_type=Release
ENV HEADLESS_BUILD=${headless_build}
LABEL BOMBSQUAD_BUILD_TYPE=${cmake_build_type}

# Install runtime dependencies
RUN useradd -m -s /bin/bash container && \
    apt-get update && \
    apt-get install -y \
        python3.12-dev && \
    if [ "$HEADLESS_BUILD" = "0" ]; then \
        apt-get install -y \
            libsdl2-dev \
            libvorbis-dev \
            libglut-dev \
            pulseaudio-utils \
            libopenal-dev; \
    fi && \
    rm -rf /var/lib/apt/lists/* && \
    python3.12 -c "import uuid; print(uuid.uuid4())" > /etc/machine-id

# Switch to non-root user
USER container
ENV USER=container HOME=/home/container

# Copy the compiled application from the builder stage
COPY --from=builder /ballistica_cmake /home/me

# Set the working directory
WORKDIR /home/container

# Copy the entrypoint script
COPY ./entrypoint.sh /entrypoint.sh

# Download config.toml
RUN curl -L -o /home/container/config.toml \
    https://raw.githubusercontent.com/Mikahael/ballistica/refs/heads/main/src/assets/server_package/config.toml

# Give execution permission
USER root
RUN chmod +x /entrypoint.sh && chown -R container:container /home/me /home/container/config.toml
USER container

# Expose BombSquad server port
EXPOSE 43210/udp

# Set the default command to run the application
CMD ["/entrypoint.sh"]
