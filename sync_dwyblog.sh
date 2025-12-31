#!/bin/bash

# 获取当前时间
NOW=$(date +'%Y-%m-%d %H:%M:%S')

echo "---------------------------------------"
echo "🚀 dwy 来了，全自动同步开启！"
echo "---------------------------------------"

# 1. 先调用图片优化功能 (直接复用你刚修好的 img_fix.sh 逻辑)
if [ -f "img_fix.sh" ]; then
    echo "📸 正在执行图片瘦身计划..."
    bash img_fix.sh
else
    echo "⚠️ 提醒：未找到 img_fix.sh，跳过图片压缩，直接同步。"
fi

echo "📂 正在同步到 GitHub..."

# 2. Git 推送
git add .
git commit -m "dwyblog 自动优化同步: $NOW"
git push

echo "---------------------------------------"
echo "🎉 搞定！部署已触发。 (完成时间: $NOW)"
echo "---------------------------------------"
