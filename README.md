# AutoSkipp - Oh My Zsh Plugin

Automatic countdown and skip functionality for Claude Code interactions.

## Installation

### One-Line Installation

```bash
curl -fsSL https://raw.githubusercontent.com/lucianfialho/.../main/install.sh | bash
```

### Manual Installation 

```bash
git clone https://github.com/yourusername/autoskipp.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoskipp
echo 'plugins+=(autoskipp)' >> ~/.zshrc
source ~/.zshrc
```

## Usage

### CLI Usage

```bash
...                              # Default 5-second countdown
... --skiptime 3                 # Custom countdown time
... --message "Loading"          # Custom message
... --auto                       # Only run if Claude Code detected
... --help                       # Show help
```

### Short Flags

```bash
... -t 10                        # --skiptime 10
... -m "Waiting"                 # --message "Waiting"
... -a                           # --auto
... -h                           # --help
```

### Quick Aliases

- `ask` - Same as `...` (5 seconds)
- `skip` - Same as `... -t 3`

## Features

- 🎯 **Smart Detection**: Automatically detects Claude Code processes
- ⏰ **Visual Countdown**: Beautiful progress bar with countdown
- 🤖 **Auto Response**: Sends automated "yes" responses on macOS
- ⚡ **Quick Aliases**: Fast access with short commands
- 🔍 **Process Hook**: Monitors command execution for Claude

## Platform Support

- **macOS**: Full support with AppleScript automation
- **Linux**: Basic countdown and detection (automation limited)
- **Windows**: Basic countdown only

## Examples

```bash
# Basic usage
autoskipp

# Custom countdown
autoskipp 7

# Only run if Claude Code is active
autoskipp_auto

# Quick shortcuts
skip      # 3 seconds
quick     # 1 second
```

## How It Works

1. Detects if Claude Code is running using process detection
2. Shows visual countdown with progress bar
3. Automatically sends responses via system automation
4. Integrates seamlessly with your Zsh workflow

Perfect for automating repetitive Claude Code interactions! 🚀