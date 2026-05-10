# Unlock GPG Key

Ensures the GPG signing key is unlocked before a commit. Detects the OS and delegates to the appropriate platform-specific approach. If the key is already cached, the unlock is a no-op.

Use this proactively before git commits to ensure GPG signing will succeed.

## Instructions

### Step 1: Detect the platform

```bash
uname -r
```

- Contains `microsoft` or `WSL` → follow `references/wsl.md`
- Otherwise → follow `references/osx.md`

### Step 2: Follow the platform-specific instructions

See the relevant reference file for the full unlock flow.
