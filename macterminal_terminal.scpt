on run argv
	-- Don't set if no path to use
	if (count of argv) is 1 then
		set folderName to item 1 of argv -- Folder path
	end if
	
	try
		if folderName is not missing value then
			set commandToRun to "cd " & quoted form of (folderName as string)
		end if
	on error
		set commandToRun to "cd /tmp"
	end try
	
	set originalSwooshValue to do shell script "defaults read com.apple.Dock workspaces-auto-swoosh"
	do shell script "defaults write com.apple.Dock workspaces-auto-swoosh -bool NO && killall Dock"
	delay 0.5
	
	try
		tell application "System Events"
			tell process "Terminal"
				set windowCount to (count of windows)
			end tell
		end tell
	on error exception
		set windowCount to 0
	end try
	
	tell application "Terminal" to activate
	tell application "System Events"
		delay 0.5
		tell process "Terminal"
			if (count of windows) is 0 then
				click menu item "New Window" of menu "Shell" of menu bar 1
			else
				if windowCount is not 0 then
					click menu item "New Tab" of menu "Shell" of menu bar 1
				end if
			end if
		end tell
		tell application "Terminal"
			set window_id to id of first window of application "Terminal" whose frontmost is true
			do script commandToRun in window id window_id of application "Terminal"
		end tell
		delay 0.5
		tell application "System Events" to keystroke "k" using command down
	end tell
	
	if originalSwooshValue is 1 then
		do shell script "defaults write com.apple.Dock workspaces-auto-swoosh -bool YES && killall Dock"
	end if
	
end run

(*
on run argv
    -- Don't set if no path to use
    if count of argv is 1 then
        set folderName to item 1 of argv -- Folder path
    end if
    
    tell application "Terminal"
        set windowsCount to (count of windows)
        if windowsCount is 0 then
            do script ""
        end if
        activate
        set window_id to id of first window whose frontmost is true
        
        if folderName is not missing value then
            if windowsCount is not 0 then
                tell application "System Events"
                    keystroke ("t" as string) using {command down} & return
                end tell
            end if

            set commandToRun to "cd " & quoted form of (folderName as string)

            do script commandToRun in window id window_id of application "Terminal"
            do script "clear" in window id window_id of application "Terminal"
        end if
    end tell
end run
*)
