#!/bin/bash
cd /app

# 确保必要的目录存在
mkdir -p /app/iso /app/data /app/log

# 【新增关键步骤】：如果映射的 data 目录是空的，就把模板文件复制进去
if [ ! -f "/app/data/iventoy.dat" ]; then
    echo "初始化 data 目录..."
    cp -a /app/data_template/* /app/data/
fi

touch /app/log/log.txt

# 启动 iVentoy
bash iventoy.sh start

# 捕获退出信号，优雅关闭
trap "bash iventoy.sh stop; exit 0" SIGINT SIGTERM

# 挂起容器并输出日志
tail -f /app/log/log.txt & wait
