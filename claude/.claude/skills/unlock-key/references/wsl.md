# Unlock GPG Key — WSL

Opens a new Windows Terminal window, sends Ctrl+D to trigger the pinentry passphrase prompt, and blocks on a named pipe until the script signals completion. If the key is already cached, `unlockKey` completes silently with no prompt.

## Instructions

Create a named pipe for signaling, write a temp script that runs `unlockKey` and signals when done, then launch it and block until the signal arrives:

```bash
CWD="$(pwd)"
SIGNAL_PIPE=$(mktemp -u /tmp/gpg_signal_XXXXX)
mkfifo "$SIGNAL_PIPE"
TMPSCRIPT=$(mktemp /tmp/unlock_XXXXX.sh)
printf '#!/bin/bash\ncd "%s" && unlockKey\necho done > "%s"\n' "$CWD" "$SIGNAL_PIPE" > "$TMPSCRIPT"
chmod +x "$TMPSCRIPT"
cmd.exe /c start wt.exe wsl.exe -e bash -i "$TMPSCRIPT"
sleep 0.5
powershell.exe -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('^d')"
cat "$SIGNAL_PIPE"
rm -f "$TMPSCRIPT" "$SIGNAL_PIPE"
```

`cat "$SIGNAL_PIPE"` blocks until `unlockKey` completes. No polling, no user confirmation needed.
