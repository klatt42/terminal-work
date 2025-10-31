# Terminal Setup Troubleshooting

## Issue: "set-serp command not found" in New Tabs

### Symptoms
- Commands work in current terminal
- New tabs/windows show "command not found"
- Need to run `source ~/.bashrc` in every new tab

### Root Cause
Windows Terminal/WSL might not be loading `.bashrc` automatically in new tabs.

---

## ✅ Solutions

### Solution 1: Manual Source (Temporary)

**In each new tab:**
```bash
source ~/.bashrc
set-serp  # Now works
```

### Solution 2: Check Bash Login Mode

**Test what bash mode is loading:**
```bash
echo $0
```

**If shows `-bash`:** Interactive login shell (loads .bash_profile, then .bashrc)
**If shows `bash`:** Interactive non-login shell (should load .bashrc)

### Solution 3: Ensure .bashrc is Loaded from .bash_profile

**Check if .bash_profile exists and loads .bashrc:**
```bash
cat ~/.bash_profile
```

**Should contain:**
```bash
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
```

**If .bash_profile doesn't exist or doesn't load .bashrc, create/fix it:**
```bash
cat >> ~/.bash_profile << 'EOF'
# Load .bashrc for all shells
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
EOF
```

### Solution 4: Windows Terminal Settings

**Check Windows Terminal settings.json:**

1. Open Windows Terminal
2. Click dropdown arrow (⌄) → Settings
3. Find your WSL profile
4. Check the "Command line" setting

**Should be one of:**
```json
"commandline": "wsl.exe"
or
"commandline": "wsl.exe ~"
or
"commandline": "wsl.exe -d Ubuntu"
```

**Add this to ensure login shell:**
```json
"commandline": "wsl.exe bash -l"
```

The `-l` flag makes bash run as login shell, which loads .bash_profile (which loads .bashrc).

---

## 🎯 Quick Fix Right Now

### For This Session

**Every time you open a new tab, run:**
```bash
source ~/.bashrc && set-serp
```

Or:
```bash
source ~/.bashrc && set-erp
```

One line, loads everything and sets context.

---

## 🔧 Permanent Fix

### Option A: Fix .bash_profile

```bash
# Create/update .bash_profile to always load .bashrc
cat > ~/.bash_profile << 'EOF'
# Load .bashrc for interactive shells
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
EOF
```

### Option B: Update Windows Terminal Settings

1. Open Windows Terminal Settings (Ctrl+,)
2. Find your WSL profile (usually "Ubuntu" or "Ubuntu-22.04")
3. Find the "Command line" field
4. Change to: `wsl.exe bash -l`
5. Save

**Before:**
```json
{
    "commandline": "wsl.exe",
    ...
}
```

**After:**
```json
{
    "commandline": "wsl.exe bash -l",
    ...
}
```

---

## ✅ Verify It's Working

### Test 1: Open New Tab

```bash
# Open new tab (Ctrl+Shift+T)
# Should see terminal-work aliases loaded message
# Try:
set-master
# Should work without source ~/.bashrc
```

### Test 2: Check Loaded Functions

```bash
# In new tab, check if functions exist
type set-master
# Should show: "set-master is a function"
# NOT: "command not found"
```

---

## 📋 Current Workaround

Until you apply permanent fix, **use this pattern:**

### New Tab for SERP Master
```bash
source ~/.bashrc && set-serp && npm run dev
```

### New Tab for My-ERP-Plan
```bash
source ~/.bashrc && set-erp && npm run dev
```

### New Tab for ROK Copilot
```bash
source ~/.bashrc && set-rok && npm run dev
```

**One line does everything:**
1. Loads aliases
2. Sets context
3. Starts dev server

---

## 🎯 Alternative: Create Simple Aliases

Add to `~/.bashrc` (these will always work):

```bash
# Simple project starters that don't rely on functions
alias start-serp-full='cd ~/serp-master && npm run dev'
alias start-erp-full='cd ~/projects/genesis-skills-test/my-erp-plan && npm run dev'
alias start-rok-full='cd ~/projects/rok-copilot && npm run dev'
```

Then in new tabs:
```bash
start-serp-full
# Works even if bash-aliases.sh didn't load
```

---

## 💡 Why This Happens

### Bash Shell Types

**Login Shell:**
- Runs on initial login
- Loads: `/etc/profile` → `~/.bash_profile` → `~/.bashrc`
- Flag: `bash -l` or `bash --login`

**Interactive Non-Login Shell:**
- Runs for new terminals/tabs
- Loads: `~/.bashrc` only
- Flag: `bash` (default)

**Your Situation:**
- New tabs might be starting as non-login shells
- Not loading .bash_profile
- Should still load .bashrc but might not be
- Windows Terminal specific behavior

---

## 🔍 Diagnostic Commands

### Check Current Shell Mode
```bash
echo $0
# -bash = login shell
# bash = non-login shell
```

### Check if .bashrc Ran
```bash
# Look for your custom aliases
alias | grep set-master
# Should show the function if .bashrc loaded
```

### Check What Files Were Sourced
```bash
# See bash startup files
ls -la ~/ | grep bash
# Should see: .bashrc, .bash_profile, .bash_history, .bash_logout
```

---

## ✅ Recommended Solution Order

1. **Immediate:** Use `source ~/.bashrc && set-serp` pattern
2. **Quick Fix:** Create `.bash_profile` that sources `.bashrc`
3. **Long-term:** Update Windows Terminal settings to use `bash -l`
4. **Verify:** Test in new tabs

---

## 📚 Additional Resources

- Bash startup files: https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html
- Windows Terminal docs: https://docs.microsoft.com/en-us/windows/terminal/

---

**Status:** Workaround provided, permanent fix documented
**Last Updated:** 2025-10-30
