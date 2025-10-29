# Installing Terminal Work Aliases

## Quick Setup

Add this line to your `~/.bashrc`:

```bash
echo "source ~/projects/terminal-work/config/bash-aliases.sh" >> ~/.bashrc
source ~/.bashrc
```

## Available Aliases

### Quick Commits
```bash
qc "Add: morning notes"          # Quick commit
commit "Create: new script"      # Same as qc
acp "Update: documentation"      # Add all, commit, push
qp                               # Quick push
```

### End of Day
```bash
eod                              # Run end-of-day workflow
endday                          # Same as eod
```

### Context Management
```bash
sync-context                     # Sync AI context files
ctx                             # Same as sync-context
```

### Navigation
```bash
tw                              # Go to terminal-work
tws                             # Go to terminal-work + git status
```

## Manual Installation

If you prefer to add aliases manually, copy them from:
`config/bash-aliases.sh`

## Verification

After installation, run:
```bash
source ~/.bashrc
tw
qc --help
```
