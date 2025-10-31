# Windows Terminal Tab Title Fix

## Problem
Commands work (`set-serp`, `set-master`, etc.) but tab titles don't change visually in Windows Terminal.

## Quick Fix

### Method 1: Windows Terminal Settings (Recommended)

1. **Open Windows Terminal Settings**
   - Press `Ctrl+,` OR
   - Click dropdown (⌄) → Settings

2. **Find Your Ubuntu/WSL Profile**
   - Click "Ubuntu" (or your WSL distro name) in left sidebar

3. **Go to "Advanced" Tab**
   - Scroll down in the profile settings

4. **Enable "Use application title"**
   - Look for: "Suppress application title"
   - Make sure it's **OFF** (toggle should be to the left/grey)

5. **Alternative: Edit JSON Directly**
   - Click "Open JSON file" at bottom left
   - Find your Ubuntu profile
   - Add or modify:
   ```json
   {
       "profiles": {
           "list": [
               {
                   "name": "Ubuntu",
                   "suppressApplicationTitle": false,
                   ...
               }
           ]
       }
   }
   ```

6. **Save and Restart**
   - Save settings
   - Close and reopen Windows Terminal
   - Try `set-master` again

### Method 2: Use ANSI Escape Codes (Alternative)

If Method 1 doesn't work, we can use a different escape sequence:

**Edit the script to use OSC 2 sequence:**

```bash
# In set-terminal-title.sh, change the set_title function
set_title() {
    local title="$1"

    # Try multiple methods
    printf "\033]0;${title}\007"     # Original
    printf "\033]2;${title}\007"     # OSC 2
    echo -ne "\033]0;${title}\007"   # With echo
}
```

### Method 3: PowerShell Integration (For Windows Terminal)

**Create a companion PowerShell script:**

File: `~/projects/terminal-work/scripts/set-title.ps1`
```powershell
param([string]$title)
$Host.UI.RawUI.WindowTitle = $title
```

Then modify bash function:
```bash
set_title() {
    local title="$1"

    # Set in WSL
    echo -ne "\033]0;${title}\007"

    # Also try PowerShell method (if available)
    if command -v powershell.exe &> /dev/null; then
        powershell.exe -Command "\$Host.UI.RawUI.WindowTitle = '$title'" 2>/dev/null
    fi
}
```

---

## ✅ Quick Test

After applying fix, test in terminal:

```bash
echo -ne "\033]0;TEST TITLE\007"
```

**Look at the tab.** If it changes to "TEST TITLE", it's working!

Then try:
```bash
set-master
```

Tab should change to "🎯 MASTER"

---

## 🎯 Workaround: Use Prompt Instead

While we fix the tab title, you can still see project context in the **prompt**:

```bash
# Load the enhanced prompt
source ~/projects/terminal-work/config/bash-prompt-project.sh
```

Then your prompt will show:
```
[🎯 MASTER] klatt42@Ron2024Work:~/projects/terminal-work$
[SERP] klatt42@Ron2024Work:~/serp-master$
[ERP] klatt42@Ron2024Work:~/my-erp-plan$
```

This gives you visual identification even if tabs don't update!

---

## 🔍 Debugging

### Check if escape codes are sent:
```bash
set-serp | cat -v
# Should see: ^[]0;SERP Master^G
```

### Check Windows Terminal version:
- Click dropdown → Settings → About
- Should be version 1.15+ for best compatibility

### Test with simple title:
```bash
echo -ne "\033]0;HELLO\007"
# Check if tab changes to "HELLO"
```

---

## 💡 Alternative: Use Window Title + Visual Prompt

Since Windows Terminal tab titles can be finicky, **best practice is to use both:**

1. **Prompt badge** - Always visible, always works
   ```bash
   [SERP] klatt42@hostname:~/serp-master$
   ```

2. **Tab title** - Nice to have when it works
   ```
   Tab: SERP Master
   ```

**Enable enhanced prompt:**
```bash
# Add to ~/.bashrc (I can add this for you)
source ~/projects/terminal-work/config/bash-prompt-project.sh
```

This way you have clear visual identification regardless of tab title!

---

## 📋 Summary

**Immediate workaround:**
- Enhanced prompt shows project badge: `[SERP]`, `[ERP]`, `[🎯 MASTER]`
- This works 100% reliably

**Fix tab titles:**
1. Windows Terminal Settings → Ubuntu profile
2. Advanced → Turn OFF "Suppress application title"
3. Restart terminal

**Test working:**
```bash
echo -ne "\033]0;TEST\007"
# Tab should change to "TEST"
```

Then:
```bash
set-serp
# Tab should change to "SERP Master"
```

---

**Status:** Diagnosis provided, multiple solutions available
**Last Updated:** 2025-10-30
