#!/bin/bash

# 删除脚本文件
rm -f /usr/local/bin/check_all_docker_mem.sh

# 删除 cron 定时任务
crontab -l | grep -v "/usr/local/bin/check_all_docker_mem.sh" | crontab -

echo "卸载成功！脚本已被删除，并且定时任务已清除。"
