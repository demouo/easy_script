#!/bin/bash

# 获取tmux会话列表
session_list=($(tmux ls | cut -d ':' -f 1))
session_count=${#session_list[@]}

# 如果没有会话，退出
if [ $session_count -eq 0 ]; then
    echo "当前没有tmux会话。"
    exit 1
fi

# 罗列所有的session并显示序号
echo "当前的tmux会话列表："
for ((i=0; i<session_count; i++)); do
    echo "$((i+1)). ${session_list[$i]}"
done

# 提示用户输入序号，添加默认值提示
read -p "请输入你要进入的会话序号 (1-$session_count) [默认为1]： " choice

# 如果用户直接按回车，设置choice为1
if [ -z "$choice" ]; then
    choice=1
fi

# 检查输入是否为有效的数字
if [[ $choice =~ ^[0-9]+$ ]]; then
    index=$((choice - 1))
    if [[ $index -ge 0 && $index -lt $session_count ]]; then
        selected_session=${session_list[$index]}
        tmux attach -t "$selected_session"
    else
        echo "输入的序号无效，请输入一个在 1 到 $session_count 之间的数字。"
    fi
else
    echo "输入的不是有效的数字，请输入一个整数。"
fi