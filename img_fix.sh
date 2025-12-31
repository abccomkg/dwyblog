#!/bin/bash
echo "📸 正在进行地毯式图片链接修复..."

# 递归处理所有图片
find content/post -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | while read -r img; do
    dir=$(dirname "$img")
    base=$(basename "$img")
    filename="${base%.*}"
    
    # 转换图片
    if cwebp -q 75 "$img" -o "$dir/$filename.webp" > /dev/null 2>&1; then
        echo "✅ 已转换: $filename.webp"
        
        # 【核心修复】：在整个 content 目录下搜索并替换，不限于当前文件夹
        # 使用 grep 先找一下哪些文件引用了这张图，然后精准替换
        grep -rl "$base" content/ | xargs -r sed -i "s/$base/$filename.webp/g"
        
        # 删除原图
        rm "$img"
    fi
done
echo "✨ 修复完成，现在所有链接应该都指向 .webp 了！"
