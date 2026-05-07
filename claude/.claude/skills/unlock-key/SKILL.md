# Unlock GPG Key

Opens an iTerm window to run `unlockKey`, sends Ctrl+D to trigger the password prompt, then waits for close.

Use this proactively before git commits to ensure GPG signing will succeed.

## Instructions

Run this AppleScript and wait for it to complete:

```bash
CWD="$(pwd)"
osascript <<APPLESCRIPT
-- Play alert sound and wait for user to stop typing
beep
delay 0.5
tell application "iTerm"
    activate
    set newWindow to (create window with default profile)
    set windowId to id of newWindow
    set theSession to current session of newWindow
    tell theSession
        write text "cd $CWD; unlockKey; sleep 3; exit"
    end tell
    -- Send Ctrl+D quickly to trigger password prompt
    delay 0.5
    tell theSession
        write text (ASCII character 4) without newline
    end tell
    -- Wait for the window to close
    repeat
        delay 0.5
        try
            set windowExists to false
            repeat with w in windows
                if id of w is windowId then
                    set windowExists to true
                    exit repeat
                end if
            end repeat
            if not windowExists then exit repeat
        on error
            -- Window already closed
            exit repeat
        end try
    end repeat
end tell
APPLESCRIPT
```

After running, proceed with the git commit.
