#!/bin/bash

# 快速邮件工具安装脚本
# 用于设置默认邮箱和权限

echo "🚀 快速邮件工具安装程序"
echo "=========================="
echo ""

# 检查是否已安装Mail应用
if ! osascript -e 'tell application "System Events" to return exists application process "Mail"' &>/dev/null; then
    echo "⚠️  警告: 未检测到Mail应用，请确保已安装并配置了邮件账户"
    echo ""
fi

# 询问用户默认邮箱
echo "📧 请输入默认接收邮箱地址:"
read -p "邮箱: " DEFAULT_EMAIL

# 验证邮箱格式
if [[ ! "$DEFAULT_EMAIL" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
    echo "❌ 邮箱格式不正确，请重新运行安装程序"
    exit 1
fi

# 保存配置到用户主目录
echo "$DEFAULT_EMAIL" > ~/.shortcut_email_config
echo "✅ 默认邮箱已设置为: $DEFAULT_EMAIL"
echo ""

# 编译AppleScript
echo "🔧 编译AppleScript..."
if osacompile -o "Quick Email.app" quick_email.scpt; then
    echo "✅ AppleScript编译成功"
else
    echo "❌ AppleScript编译失败"
    exit 1
fi

echo ""
echo "🎉 安装完成！"
echo ""
echo "📋 接下来的手动步骤："
echo "1. 打开 '自动操作' (Automator) 应用"
echo "2. 创建新文档，选择 '快速操作'"
echo "3. 在工作流程中添加 '运行AppleScript' 操作"
echo "4. 将 quick_email.scpt 的内容复制到脚本区域"
echo "5. 在右上角设置:"
echo "   - 工作流程接收: 文件或文件夹"
echo "   - 位于: 访达"
echo "6. 保存为 '快速邮件发送'"
echo ""
echo "💡 完成后，在Finder中右键点击文件即可看到 '快速邮件发送' 选项"
echo ""
echo "🔧 其他说明:"
echo "- 配置文件位置: ~/.shortcut_email_config"
echo "- 如需修改默认邮箱，编辑该文件或重新运行此安装程序"
echo "- 首次使用可能需要授权访问邮件应用"