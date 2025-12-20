#!/bin/bash

# 获取电池电量（取整数）
BATTERY_NUM=$(acpi | rg --pcre2 -o '[0-9]+(?=%)')
# echo "当前电池电量：$BATTERY_NUM"

# 获取电池状态（是否在充电）
BATTERY_STATUS=$(acpi | rg -o '(Full|Charging|Discharging)')
# echo "当前电池状态：$BATTERY_STATUS"

# 当电量低于20%且未充电时，播放提示音
if [ "$BATTERY_NUM" -lt 20 ] && [ "$BATTERY_STATUS" == "Discharging" ]; then
	# 使用系统默认提示音，也可替换为自己的音频文件路径
	paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga
fi

