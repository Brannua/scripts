#!/bin/bash

# =======================================
# 音乐（电脑播放的）-> 流入水池，即：采集BGM
# 
# 你的人声 -> 流入水池，即：采集人声
# 
# 水池有俩出水口：
# 
# 出水口A -> SimpleScreenRecorder 录音，即：同时录到BGM和人声
# 
# 出水口B -> 耳机，即：耳机里能同时听到BGM和人声
# =======================================

echo "=== 查找音频设备 ==="

UGREEN_IN=$(pactl list short sources | rg input | tail -1 | awk '{print $2}')
echo "你的输入设备：$UGREEN_IN"

UGREEN_OUT=$(pactl list short sinks | rg output | tail -1 | awk '{print $2}')
echo "你的输出设备：$UGREEN_OUT"

pactl unload-module module-null-sink 2>/dev/null
pactl unload-module module-loopback 2>/dev/null

echo "=== 创建虚拟混音池 ==="
pactl load-module module-null-sink sink_name=record_pool
echo "=== 正在配置音频流 ==="
pactl set-default-sink record_pool
pactl load-module module-loopback source="$UGREEN_IN" sink=record_pool latency_msec=5
pactl load-module module-loopback source=record_pool.monitor sink="$UGREEN_OUT"

echo "✅配置完成！"
echo "在 Simple Screen Recorder 中："
echo "1. 勾选 'Record audio'"
echo "2. Source 选择: 'Monitor of record_pool......'"
echo "3. 开始录制"

