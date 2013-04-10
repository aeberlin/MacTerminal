on run argv
    -- Don't set if no path to use
	if (count of argv) is 1 then
		set folderName to item 1 of argv -- Folder path
	end if
	
	if folderName is not missing value then
		set commandToRun to "cd " & quoted form of (folderName as string)
	else
		set commandToRun to "cd /tmp"
	end if
	
    -- Turn off "When switching to an application, switch to a space with open windows for the application"
	do shell script "defaults write com.apple.Dock workspaces-auto-swoosh -bool NO"
	delay 0.5

	tell application "System Events"
        -- Start Terminal and focus
		tell application "Terminal" to activate

        -- Spawn new terminal window or tab
		tell process "Terminal"
			if (count of windows) is 0 then
				beep
				click menu item "New Window" of menu "Shell" of menu bar 1
			else
				click menu item "New Tab" of menu "Shell" of menu bar 1
			end if
		end tell

        -- Change directory on front most terminal window
		tell application "Terminal"
			set window_id to id of first window of application "Terminal" whose frontmost is true
			do script commandToRun in window id window_id of application "Terminal"
		end tell
		delay 0.5

        -- Clear console scrollback
		tell application "System Events" to keystroke "k" using command down
	end tell
	
    -- Turn on "When switching to an application, switch to a space with open windows for the application"
	do shell script "defaults write com.apple.Dock workspaces-auto-swoosh -bool YES"
	
end run
