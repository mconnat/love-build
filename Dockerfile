FROM debian:buster-slim

# Install general dependencies
RUN apt-get update -q -y && apt-get install -q -y --no-install-recommends \
    lua5.1 \
    liblua5.1-0-dev \
    build-essential \
    libreadline-dev \
    wget \
    zip \
    curl \
    gnupg \
    ca-certificates \
    unzip \
    git 

# Fetch and build luarocks-3.3.1
RUN wget https://luarocks.org/releases/luarocks-3.3.1.tar.gz && \
    tar zxpf luarocks-3.3.1.tar.gz
RUN cd luarocks-3.3.1 && \
    ./configure && \
    make && make install
# Install nodejs version 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs \
    build-essential && \
    node --version && \ 
    npm --version

WORKDIR /love-build/
# Install love.js version 11.4.1
#https://www.npmjs.com/package/love.js
RUN npm install -g love.js@11.4.1

# Copy and setup entrypoint
COPY build.sh .
COPY module_loader.lua .
ENTRYPOINT ["/love-build/build.sh"]
