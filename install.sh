#!/bin/bash

# 获取用户输入的安装路径和日志路径
read -p "请输入脚本安装路径（默认：/usr/local/bin/check_all_docker_mem.sh）： " INSTALL_PATH
INSTALL_PATH="${INSTALL_PATH:-/usr/local/bin/check_all_docker_mem.sh}"

read -p "请输入日志文件路径（默认：/var/log/docker_mem）： " LOG_DIR
LOG_DIR="${LOG_DIR:-/var/log/docker_mem}"

# 让用户手动输入内存阈值（单位：MiB）
read -p "请输入每个容器的内存阈值（MiB）： " THRESHOLD

# 设定 GitHub 仓库地址
GITHUB_URL="https://raw.githubusercontent.com/SpeedCloudNoc/docker-mem-check/blob/561f9793a67dff05b7318d031226b6509a7c79da/check_all_docker_mem.sh"

# 下载脚本文件到指定路径
curl -sSL "$GITHUB_URL" -o "$INSTALL_PATH"

# 给脚本文件添加执行权限
chmod +x "$INSTALL_PATH"

# 安装 crontab，使用用户指定的安装路径和内存阈值
(crontab -l 2>/dev/null; echo "*/5 * * * * $INSTALL_PATH $LOG_DIR $THRESHOLD") | crontab -

echo "安装成功！"
echo "脚本已安装到：$INSTALL_PATH"
echo "日志文件路径设置为：$LOG_DIR"
echo "内存阈值已设置为：$THRESHOLD MiB"
echo "安装已完成，脚本将每5分钟自动运行，并使用您输入的内存阈值。"
