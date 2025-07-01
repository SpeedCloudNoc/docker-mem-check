#!/bin/bash

# 删除脚本文件
rm -f /usr/local/bin/check_all_docker_mem.sh

# 删除 cron 定时任务
crontab -l | grep -v "/usr/local/bin/check_all_docker_mem.sh" | crontab -

# 删除日志文件
LOG_DIR="/var/log/docker_mem"
if [ -d "$LOG_DIR" ]; then
    rm -rf "$LOG_DIR"
    echo "日志文件已删除：$LOG_DIR"
else
    echo "未找到日志目录：$LOG_DIR"
fi

echo "卸载成功！脚本已被删除，定时任务已清除，日志文件已删除。"
