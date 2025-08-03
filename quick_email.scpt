-- 快速邮件发送AppleScript (自动确认版本)
-- 作者：ShortCutEmail Tool
-- 用途：通过Finder右键菜单快速发送文件到指定邮箱(无需确认)

on run {input, parameters}
	-- 读取配置文件获取默认邮箱
	set configPath to (path to home folder as string) & ".shortcut_email_config"
	set defaultEmail to ""
	
	try
		set configFile to open for access file configPath
		set defaultEmail to read configFile as string
		close access configFile
		-- 移除可能的换行符
		set defaultEmail to my trimString(defaultEmail)
	on error
		close access configFile
		-- 如果配置文件不存在，提示用户输入
		display dialog "请输入默认接收邮箱地址：" default answer "" with title "快速邮件设置"
		set defaultEmail to text returned of result
		
		-- 保存到配置文件
		try
			set configFile to open for access file configPath with write permission
			write defaultEmail to configFile
			close access configFile
		on error
			try
				close access configFile
			end try
		end try
	end try
	
	-- 如果没有选中文件，退出
	if input is {} then
		display notification "请先选择要发送的文件" with title "快速邮件"
		return
	end if
	
	-- 处理选中的文件
	repeat with currentFile in input
		set fileName to name of (info for currentFile)
		set fileAlias to currentFile as alias
		
		-- 直接使用默认邮箱，无需确认
		set recipientEmail to defaultEmail
		
		-- 生成邮件主题
		set emailSubject to "文件分享: " & fileName
		
		-- 打开邮件应用并创建新邮件
		tell application "Mail"
			activate
			set newMessage to make new outgoing message with properties {subject:emailSubject, visible:true}
			
			tell newMessage
				-- 设置收件人
				make new to recipient at end of to recipients with properties {address:recipientEmail}
				
				-- 设置邮件正文
				set content to "您好，" & return & return & "请查收附件中的文件: " & fileName & return & return & "此邮件由快速邮件工具自动发送。" & return & return & "祝好！"
				
				-- 添加附件
				try
					make new attachment with properties {file name:fileAlias} at after the last paragraph
				on error errorMessage
					display notification "添加附件失败: " & errorMessage with title "快速邮件错误"
					return
				end try
			end tell
			
			-- 自动发送邮件，无需确认
			try
				send newMessage
				display notification "文件 " & fileName & " 已自动发送到 " & recipientEmail with title "快速邮件"
			on error errorMessage
				display notification "发送失败: " & errorMessage with title "快速邮件错误"
			end try
		end tell
	end repeat
	
	return input
end run

-- 字符串去空格函数
on trimString(str)
	set str to str as string
	repeat while str starts with " " or str starts with tab or str starts with return or str starts with linefeed
		set str to text 2 thru -1 of str
	end repeat
	repeat while str ends with " " or str ends with tab or str ends with return or str ends with linefeed
		set str to text 1 thru -2 of str
	end repeat
	return str
end trimString