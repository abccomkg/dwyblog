#!/bin/bash
echo "📸 正在将图片转换为高兼容性 JPG 格式..."

# 递归处理所有图片
# 注意：这次我们只处理 png 和 jpeg，如果是原本就是 jpg 的，我们进行压缩
find content/post -type f \( -name "*.png" -o -name "*.jpeg" -o -name "*.webp" -o -name "*.jpg" \) | while read -r img; do
    dir=$(dirname "$img")
    base=$(basename "$img")
    filename="${base%.*}"
    
    # 跳过已经是处理好的 .jpg 且体积较小的文件，防止循环处理
    # 我们统一转成 .jpg
    target="$dir/$filename.jpg"
    
    # 使用 ImageMagick 进行转换和压缩
    # -quality 80 可以在保持清晰度的同时大幅减小体积
    if convert "$img" -quality 80 "$target" > /dev/null 2>&1; then
        echo "✅ 已处理: $filename.jpg"
        
        # 只有当新旧文件名不同时，才替换链接并删除原图
        if [ "$img" != "$target" ]; then
            grep -rl "$base" content/ | xargs -r sed -i "s/$base/$filename.jpg/g"
            rm "$img"
        fi
    fi
done
echo "✨ 所有图片已转为 JPG 并更新链接！"
