#!/bin/bash

# 获取电池电量（取整数）
BATTERY_NUM=$(acpi | rg --pcre2 -o '[0-9]+(?=%)')
# echo "当前电池电量：$BATTERY_NUM"

# 定义剩余多少电量时为低电量
BATTERY_LOW_AT=30

# 获取电池状态（是否在充电）
BATTERY_STATUS=$(acpi | rg -o '(Full|Charging|Discharging)')
# echo "当前电池状态：$BATTERY_STATUS"

# 当处于电池放电状态并且电量低于$BATTERY_LOW_AT%时，播放提示音
if [ "$BATTERY_NUM" -lt "$BATTERY_LOW_AT" ] && [ "$BATTERY_STATUS" = "Discharging" ]; then
	# 播放系统默认提示音，也可替换为自己的音频文件
	paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga
fi

