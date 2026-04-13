#!/bin/bash
cd /app

# 确保必要的目录存在
mkdir -p /app/iso /app/data /app/log
touch /app/log/log.txt

# 启动 iVentoy
bash iventoy.sh start

# 捕获退出信号，优雅关闭
trap "bash iventoy.sh stop; exit 0" SIGINT SIGTERM

# 挂起容器并输出日志
tail -f /app/log/log.txt & wait
