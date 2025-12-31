#!/bin/bash
# 强力诊断版

# 检查工具是否存在
if ! command -v cwebp &> /dev/null; then
    echo "❌ 错误：未发现 cwebp 工具，正在尝试安装..."
    pkg install webp -y
fi

# 这里的路径一定要带引号，防止空格报错
find "content/post" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | while read -r img; do
    dir=$(dirname "$img")
    base=$(basename "$img")
    filename="${base%.*}"
    
    echo "------------------------------"
    echo "🔍 发现图片: $img"
    
    # 尝试转换并捕获错误信息
    if cwebp -q 75 "$img" -o "$dir/$filename.webp" 2>&1; then
        # 检查生成的 webp 是否真的存在且大于 0 字节
        if [ -s "$dir/$filename.webp" ]; then
            # 替换 md 链接
            sed -i "s/$base/$filename.webp/g" "$dir"/*.md
            # 删除原图
            rm "$img"
            echo "✅ 转换成功: $filename.webp"
        else
            echo "⚠️ 转换后的文件为空，已跳过删除原图"
        fi
    else
        echo "❌ 转换失败！请检查图片格式是否损坏"
    fi
done
