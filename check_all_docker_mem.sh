#!/usr/bin/env bash
#
# 遍历所有运行中的 Docker 容器；若内存占用 > THRESHOLD (MiB) 则重启该容器。
# 同时把信息分别写入：
#   1) /var/log/docker_mem/all.log         —— 汇总日志
#   2) /var/log/docker_mem/<NAME>.log      —— 单容器日志
#
# 同时保留最近1天的日志，删除过期日志。

set -euo pipefail

# 让用户手动输入内存阈值（单位：MiB）
read -p "请输入每个容器的内存阈值（MiB）： " THRESHOLD

LOG_DIR="/var/log/docker_mem"
mkdir -p "$LOG_DIR"
AGG_LOG="$LOG_DIR/all.log"

exec >>"$AGG_LOG" 2>&1               # 汇总日志：stdout / stderr 全收

timestamp() { date "+%F %T"; }

# 删除超过1天的日志文件
find "$LOG_DIR" -type f -name "*.log" -mtime +1 -exec rm -f {} \;

docker ps --format "{{.ID}} {{.Names}}" | while read -r cid cname; do
  # docker stats 输出形如 "261.4MiB / 7.7GiB"
  raw=$(docker stats --no-stream --format "{{.MemUsage}}" "$cid" | awk -F/ "{print \$1}")
  value=$(echo "$raw" | sed "s/[^0-9.]//g")          # 数字部分
  unit=$(echo "$raw"  | sed "s/[0-9. //]*//g")       # 单位

  # 转换为 MiB 统一比较
  case "$unit" in
      GiB|GB) mem_mib=$(echo "$value*1024" | bc) ;;
      MiB|MB) mem_mib=$value ;;
      KiB|KB) mem_mib=$(echo "$value/1024" | bc) ;;
      B)      mem_mib=$(echo "$value/1048576" | bc) ;;
      *)      mem_mib=0 ;;
  esac

  log_line="$(timestamp) | ${cname} (${cid}) | mem=${mem_mib} MiB | threshold=${THRESHOLD} MiB"

  if (( $(echo "$mem_mib > $THRESHOLD" | bc -l) )); then
      echo "$log_line | ACTION: restart" | tee -a "$LOG_DIR/${cname}.log"
      docker restart "$cid"
  else
      echo "$log_line | STATUS: ok" | tee -a "$LOG_DIR/${cname}.log"
  fi
done
