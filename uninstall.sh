#!/bin/bash

# 快速邮件工具卸载脚本

echo "🗑️  快速邮件工具卸载程序"
echo "=========================="
echo ""

echo "⚠️  此操作将删除:"
echo "- 配置文件 (~/.shortcut_email_config)"
echo "- 编译的应用文件"
echo ""

read -p "确定要继续吗？(y/N): " confirm

if [[ $confirm != [yY] ]]; then
    echo "❌ 取消卸载"
    exit 0
fi

# 删除配置文件
if [ -f ~/.shortcut_email_config ]; then
    rm ~/.shortcut_email_config
    echo "✅ 已删除配置文件"
else
    echo "ℹ️  配置文件不存在"
fi

# 删除编译的应用文件
if [ -d "Quick Email.app" ]; then
    rm -rf "Quick Email.app"
    echo "✅ 已删除应用文件"
else
    echo "ℹ️  应用文件不存在"
fi

echo ""
echo "⚠️  请手动删除Automator中的快速操作:"
echo "1. 打开自动操作 (Automator)"
echo "2. 选择文件 > 打开快速操作文件夹"
echo "3. 删除 '快速邮件发送.workflow' 文件"
echo ""
echo "🎉 卸载完成！"