FROM ubuntu:18.04

ARG LLVM_VERSION=13

ENV RUSTUP_HOME=/usr/local/rustup \
  CARGO_HOME=/usr/local/cargo \
  PATH=/usr/local/cargo/bin:$PATH \
  CC=clang \
  CXX=clang++ \
  CC_x86_64_unknown_linux_gnu=clang \
  CXX_x86_64_unknown_linux_gnu=clang++ \
  RUST_TARGET=x86_64-unknown-linux-gnu \
  LDFLAGS="-fuse-ld=lld"

RUN apt-get update && \
  apt-get install -y --fix-missing --no-install-recommends gpg-agent ca-certificates openssl wget gnupg curl && \
  wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
  echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-${LLVM_VERSION} main" >> /etc/apt/sources.list && \
  echo "deb-src http://apt.llvm.org/bionic/ llvm-toolchain-bionic-${LLVM_VERSION} main" >> /etc/apt/sources.list && \
  curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
  apt-get install -y --fix-missing --no-install-recommends \
  llvm-${LLVM_VERSION} \
  clang-${LLVM_VERSION} \
  lld-${LLVM_VERSION} \
  libc++-${LLVM_VERSION}-dev \
  libc++abi-${LLVM_VERSION}-dev \
  nodejs \
  xz-utils \
  rcs \
  git \
  make \
  cmake \
  ninja-build && \
  apt-get autoremove -y && \
  curl https://sh.rustup.rs -sSf | sh -s -- -y && \
  npm install -g yarn pnpm lerna && \
  ln -sf /usr/bin/clang-${LLVM_VERSION} /usr/bin/clang && \
  ln -sf /usr/bin/clang++-${LLVM_VERSION} /usr/bin/clang++ && \
  ln -sf /usr/bin/lld-${LLVM_VERSION} /usr/bin/lld && \
  ln -sf /usr/bin/clang-${LLVM_VERSION} /usr/bin/cc

ARG NASM_VERSION=2.16.01
RUN wget https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VERSION}/nasm-${NASM_VERSION}.tar.xz && \
  tar -xf nasm-${NASM_VERSION}.tar.xz && \
  cd nasm-${NASM_VERSION} && \
  ./configure --prefix=/usr/ && \
  make && \
  make install && \
  cd / && \
  rm -rf nasm-${NASM_VERSION} && \
  rm nasm-${NASM_VERSION}.tar.xz
