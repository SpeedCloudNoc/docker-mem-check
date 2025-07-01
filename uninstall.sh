#!/bin/bash

# 用户输入安装路径和日志路径
read -p "请输入脚本安装路径（默认：/usr/local/bin/check_all_docker_mem.sh）： " INSTALL_PATH
INSTALL_PATH="${INSTALL_PATH:-/usr/local/bin/check_all_docker_mem.sh}"

read -p "请输入日志文件路径（默认：/var/log/docker_mem）： " LOG_DIR
LOG_DIR="${LOG_DIR:-/var/log/docker_mem}"

# 删除脚本文件
if [ -f "$INSTALL_PATH" ]; then
    rm -f "$INSTALL_PATH"
    echo "脚本文件已删除：$INSTALL_PATH"
else
    echo "未找到脚本文件：$INSTALL_PATH"
fi

# 删除 cron 定时任务
crontab -l | grep -v "$INSTALL_PATH" | crontab -
echo "定时任务已清除。"

# 删除日志文件
if [ -d "$LOG_DIR" ]; then
    rm -rf "$LOG_DIR"
    echo "日志文件已删除：$LOG_DIR"
else
    echo "未找到日志目录：$LOG_DIR"
fi

echo "卸载成功！"
echo "以下文件已被删除："
echo "脚本文件：$INSTALL_PATH"
echo "日志文件目录：$LOG_DIR"
echo "定时任务已清除。"
