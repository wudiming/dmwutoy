FROM debian:bookworm-slim

# 通过构建参数传入版本号
ARG IVENTOY_VERSION
ENV IVENTOY_VERSION=${IVENTOY_VERSION}

# 安装基础依赖
RUN apt-get update && \
    apt-get install -y wget curl bash tar jq && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 注意：从 1.0.27 版本开始，官方包名增加了 -x86_64 标识
# 使用 --strip-components=1 直接将内容解压到当前 /app 目录，省去 mv 操作
RUN wget https://github.com/ventoy/PXE/releases/download/v${IVENTOY_VERSION}/iventoy-${IVENTOY_VERSION}-linux-x86_64-free.tar.gz -O iventoy.tar.gz && \
    tar -xzf iventoy.tar.gz --strip-components=1 && \
    rm -rf iventoy.tar.gz

# 将自带的 data 目录备份一份，用于首次启动时填充配置
RUN cp -r data data_template

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# 挂载关键目录
VOLUME ["/app/iso", "/app/data", "/app/log"]

# 暴露端口
EXPOSE 26000 16000 67/udp 69/udp 10809

ENTRYPOINT ["/app/entrypoint.sh"]
