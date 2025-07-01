#!/bin/bash

# 设定 GitHub 仓库地址
GITHUB_URL="https://raw.githubusercontent.com/SpeedCloudNoc/docker-mem-check/174a65ade9a022302ade98c1ef768cc1a89394d5/check_all_docker_mem.sh"
INSTALL_PATH="/usr/local/bin/check_all_docker_mem.sh"

# 下载脚本文件到指定路径
curl -sSL "$GITHUB_URL" -o "$INSTALL_PATH"

# 给脚本文件添加执行权限
chmod +x "$INSTALL_PATH"

# 安装 crontab
(crontab -l 2>/dev/null; echo "*/5 * * * * $INSTALL_PATH") | crontab -

echo "安装成功！脚本已安装并设置为每5分钟自动运行。"
