#!/bin/bash

# =======================================
# 音乐（电脑播放的）水管 -> 流入水池
# 
# 你的人声水管 -> 流入水池
# 
# 水池有俩出水口：
# 
# 出水口A -> SimpleScreenRecorder 录音
# 
# 出水口B -> 监听耳机
# =======================================

echo "=== 查找音频设备 ==="

MIC=$(pactl list short sources | rg input | rg -v monitor | head -1 | awk '{print $2}')
echo "你的麦克风设备：$MIC"

HP=$(pactl list short sinks | rg "analog-stereo" | head -2 | tail -1 | awk '{print $2}')
echo "你的耳机设备：$HP"

echo "=== 创建虚拟混音池 ==="

pactl unload-module module-null-sink 2>/dev/null
pactl load-module module-null-sink sink_name=record_pool

pactl set-default-sink record_pool

pactl unload-module module-loopback 2>/dev/null
pactl load-module module-loopback source="$MIC" sink=record_pool
pactl load-module module-loopback source=record_pool.monitor sink="$HP"

echo "✅ 配置完成！"
echo "在 Simple Screen Recorder 中："
echo "1. 勾选 'Record audio'"
echo "2. Source 选择: 'Monitor of recor......'"
echo "3. 开始录制"

