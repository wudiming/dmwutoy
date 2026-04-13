FROM debian:bookworm-slim

# 通过构建参数传入版本号
ARG IVENTOY_VERSION
ENV IVENTOY_VERSION=${IVENTOY_VERSION}

# 安装基础依赖
RUN apt-get update && \
    apt-get install -y wget curl bash tar jq && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 根据传入的版本号下载对应的 Release 包
RUN wget https://github.com/ventoy/PXE/releases/download/v${IVENTOY_VERSION}/iventoy-${IVENTOY_VERSION}-linux-free.tar.gz -O iventoy.tar.gz && \
    tar -xzf iventoy.tar.gz && \
    mv iventoy-${IVENTOY_VERSION}/* . && \
    rm -rf iventoy-${IVENTOY_VERSION} iventoy.tar.gz

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# 挂载关键目录：ISO镜像、数据配置、日志
VOLUME ["/app/iso", "/app/data", "/app/log"]

# 暴露端口: 26000(Web UI), 16000(内部RPC), 67(DHCP), 69(TFTP), 10809(HTTP)
EXPOSE 26000 16000 67/udp 69/udp 10809

ENTRYPOINT ["/app/entrypoint.sh"]
