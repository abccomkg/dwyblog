#!/bin/bash
echo "📸 开始优化 content/post 下的图片资源..."

# 递归查找所有图片并转换
find content/post -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | while read -r img; do
    dir=$(dirname "$img")
    base=$(basename "$img")
    filename="${base%.*}"
    
    if cwebp -q 75 "$img" -o "$dir/$filename.webp" > /dev/null 2>&1; then
        # 替换同文件夹下所有 md 文件的链接
        sed -i "s/$base/$filename.webp/g" "$dir"/*.md
        rm "$img"
        echo "✅ 处理完成: $filename.webp"
    fi
done
echo "✨ 所有图片已完成 WebP 转换！"
